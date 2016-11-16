/*
    ChibiOS/RT - Copyright (C) 2006-2013 Giovanni Di Sirio
	LED-Cube Firmware - Copyright (C) 2014 Nick Schrader

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

#include "ch.h"
#include "hal.h"
#include "usbconf.h"
#include "cubeconf.h"

#include <string.h>

/*
 * Configure Endpoint 1
 */
static USBInEndpointState ep1instate;

static USBOutEndpointState ep1outstate;

static const USBEndpointConfig ep1config = {
  USB_EP_MODE_TYPE_BULK,
  NULL,
  sduDataTransmitted,
  sduDataReceived,
  0x0040,
  0x0040,
  &ep1instate,
  &ep1outstate,
  1,
  NULL
};

/*
 * Configure Endpoint 2
 */
static USBInEndpointState ep2instate;

static const USBEndpointConfig ep2config = {
  USB_EP_MODE_TYPE_INTR,
  NULL,
  sduInterruptTransmitted,
  NULL,
  0x0010,
  0x0000,
  &ep2instate,
  NULL,
  1,
  NULL
};

static void usb_event(USBDriver *usbp, usbevent_t event) {
  switch (event) {
  case USB_EVENT_RESET:
    return;
  case USB_EVENT_ADDRESS:
    return;
  case USB_EVENT_CONFIGURED:
    chSysLockFromIsr();
    /* 
	 * Enables the endpoints specified into the configuration.
     * Note, this callback is invoked from an ISR so I-Class functions
     * must be used.
	 */
    usbInitEndpointI(usbp, USBD1_DATA_REQUEST_EP, &ep1config);
    usbInitEndpointI(usbp, USBD1_INTERRUPT_REQUEST_EP, &ep2config);
    /* Resetting the state of the CDC subsystem.*/
    sduConfigureHookI(&SDU1);
    chSysUnlockFromIsr();
    return;
  case USB_EVENT_SUSPEND:
    return;
  case USB_EVENT_WAKEUP:
    return;
  case USB_EVENT_STALLED:
    return;
  }
  return;
}

/*
 * Handles the GET_DESCRIPTOR callback. All required descriptors must be
 * handled here.
 */
static const USBDescriptor *get_descriptor(USBDriver *usbp, uint8_t dtype, uint8_t dindex, uint16_t lang) {
  (void)usbp;
  (void)lang;
  switch (dtype) {
  case USB_DESCRIPTOR_DEVICE:
    return &vcom_device_descriptor;
  case USB_DESCRIPTOR_CONFIGURATION:
    return &vcom_configuration_descriptor;
  case USB_DESCRIPTOR_STRING:
    if (dindex < 4)
      return &vcom_strings[dindex];
  }
  return NULL;
}

/*
 * USB driver configuration.
 */
static const USBConfig usbcfg = {
  usb_event,
  get_descriptor,
  sduRequestsHook,
  NULL
};

/*
 * Serial over USB driver configuration.
 */
static const SerialUSBConfig serusbcfg = {
  &USBD1,
  USBD1_DATA_REQUEST_EP,
  USBD1_DATA_AVAILABLE_EP,
  USBD1_INTERRUPT_REQUEST_EP
};

/*
 * Control the LED-Cube.
 *
 * Protocol:
 * Send 1 Command Byte + n Data Bytes
 * Recieve 1 Answer Byte
 *
 * Command		Hex		Data			Data Bytes			Answer
 * Data 		0x00	Whole Layer		BYTES_PER_LAYER		None
 * Seek			0x01	Index			1					None
 * Tell			0x02	None			0					Index
 * Reset		0x03	None			0					None
 * Interval		0x04	DELAY_PER_LAYER	1					None
 * Identify		0x2A	None			0					0xD5
 * Unlock		0x33	None			0					None
 * Lock			0xF3	None			0					None
 * None			-		-				-					0x3F
 * 
 */
static LAYER_DATA_TYPE r3[N_LAYERS];

static WORKING_AREA(draw_r3_wa, 128);

static bool_t locked = true;

static uint16_t delay = DELAY_PER_LAYER;

static msg_t draw_r3(void *p) {
  /* 0xFF was on startup the last layer, so 0 will be the first one in the first iteration */
  uint8_t j = 0xFF; 
  (void) p;
  while (TRUE) {
	if (locked) {
	  FOREACH_COLUMN(palClearPad(column[i].port, column[i].pad));
	  FOREACH_LAYER(palClearPad(layer[i].port, layer[i].pad));
	  chSysLock();
	  chSchGoSleepS(THD_STATE_SUSPENDED);
	  chSysUnlock();
	}
    palClearPad(layer[j%N_LAYERS].port, layer[j%N_LAYERS].pad);
    j++;
	FOREACH_COLUMN({
		palWritePad(column[i].port, column[i].pad, r3[j%N_LAYERS] & ((LAYER_DATA_TYPE) 1 << i) ? PAL_HIGH : PAL_LOW);
	});
	palSetPad(layer[j%N_LAYERS].port, layer[j%N_LAYERS].pad);
	chThdSleepMilliseconds(delay);
  }
  return 0;
}

int main(void) {
  Thread *tp;
  uint8_t pos = 0, ans = 0, cmd = 0;
  halInit();
  chSysInit();
  sduObjectInit(&SDU1);
  sduStart(&SDU1, &serusbcfg);
  usbStart(serusbcfg.usbp, &usbcfg);
  usbConnectBus(serusbcfg.usbp);
  FOREACH_LAYER({
	palSetPadMode(layer[i].port, layer[i].pad, PAL_MODE_OUTPUT_PUSHPULL);
	palClearPad(layer[i].port, layer[i].pad);
  });
  FOREACH_COLUMN({
	palSetPadMode(column[i].port, column[i].pad, PAL_MODE_OUTPUT_PUSHPULL);
	palClearPad(column[i].port, column[i].pad);
  });
  tp = chThdCreateStatic(draw_r3_wa, sizeof(draw_r3_wa), HIGHPRIO, draw_r3, NULL);
  while (TRUE) {
	chnRead(&SDU1, &cmd, 1);
	if (locked && cmd != 0x33)
	  continue;
	switch (cmd) {
	  case 0x00: chnRead(&SDU1, (uint8_t *) &r3[pos%N_LAYERS], BYTES_PER_LAYER);
				 pos++;
			     break; //Data
	  case 0x01: chnRead(&SDU1, &cmd, 1);
				 pos = cmd;
			     break; //Seek
	  case 0x02: ans = pos % N_LAYERS;
				 chnWrite(&SDU1, &ans, 1);
			     break; //Tell
	  case 0x03: memset(r3, 0, BYTES_PER_LAYER * N_LAYERS);
				 pos = 0;
				 delay = DELAY_PER_LAYER;
			     break; //Reset
	  case 0x04: chnRead(&SDU1, &cmd, 1);
				 delay = cmd;
				 break; //Interval
	  case 0x2A: ans = 0xD5;
				 chnWrite(&SDU1, &ans, 1);
			     break; //Identify
	  case 0x33: locked = false;
				 chSysLock();
				 chSchWakeupS(tp, RDY_OK);
				 chSysUnlock();
			     break; //Unlock
	  case 0xF3: locked = true;
			     break; //Lock
	  default  : ans = 0x3F;
				 chnWrite(&SDU1, &ans, 1);
				 break; //None
	}
  }
  return 0;
}
