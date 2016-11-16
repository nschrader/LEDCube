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

#ifndef _CHCONF_H_
#define _CHCONF_H_

#if !defined(CH_FREQUENCY) || defined(__DOXYGEN__)
#define CH_FREQUENCY                    1000
#endif

#if !defined(CH_TIME_QUANTUM) || defined(__DOXYGEN__)
#define CH_TIME_QUANTUM                 20
#endif

#if !defined(CH_MEMCORE_SIZE) || defined(__DOXYGEN__)
#define CH_MEMCORE_SIZE                 0
#endif

#if !defined(CH_NO_IDLE_THREAD) || defined(__DOXYGEN__)
#define CH_NO_IDLE_THREAD               FALSE
#endif

#if !defined(CH_OPTIMIZE_SPEED) || defined(__DOXYGEN__)
#define CH_OPTIMIZE_SPEED               TRUE
#endif

#if !defined(CH_USE_REGISTRY) || defined(__DOXYGEN__)
#define CH_USE_REGISTRY                 TRUE
#endif

#if !defined(CH_USE_WAITEXIT) || defined(__DOXYGEN__)
#define CH_USE_WAITEXIT                 TRUE
#endif

#if !defined(CH_USE_SEMAPHORES) || defined(__DOXYGEN__)
#define CH_USE_SEMAPHORES               TRUE
#endif

#if !defined(CH_USE_SEMAPHORES_PRIORITY) || defined(__DOXYGEN__)
#define CH_USE_SEMAPHORES_PRIORITY      FALSE
#endif

#if !defined(CH_USE_SEMSW) || defined(__DOXYGEN__)
#define CH_USE_SEMSW                    TRUE
#endif

#if !defined(CH_USE_MUTEXES) || defined(__DOXYGEN__)
#define CH_USE_MUTEXES                  TRUE
#endif

#if !defined(CH_USE_CONDVARS) || defined(__DOXYGEN__)
#define CH_USE_CONDVARS                 TRUE
#endif

#if !defined(CH_USE_CONDVARS_TIMEOUT) || defined(__DOXYGEN__)
#define CH_USE_CONDVARS_TIMEOUT         TRUE
#endif

#if !defined(CH_USE_EVENTS) || defined(__DOXYGEN__)
#define CH_USE_EVENTS                   TRUE
#endif

#if !defined(CH_USE_EVENTS_TIMEOUT) || defined(__DOXYGEN__)
#define CH_USE_EVENTS_TIMEOUT           TRUE
#endif

#if !defined(CH_USE_MESSAGES) || defined(__DOXYGEN__)
#define CH_USE_MESSAGES                 TRUE
#endif

#if !defined(CH_USE_MESSAGES_PRIORITY) || defined(__DOXYGEN__)
#define CH_USE_MESSAGES_PRIORITY        FALSE
#endif

#if !defined(CH_USE_MAILBOXES) || defined(__DOXYGEN__)
#define CH_USE_MAILBOXES                TRUE
#endif

#if !defined(CH_USE_QUEUES) || defined(__DOXYGEN__)
#define CH_USE_QUEUES                   TRUE
#endif

#if !defined(CH_USE_MEMCORE) || defined(__DOXYGEN__)
#define CH_USE_MEMCORE                  TRUE
#endif

#if !defined(CH_USE_HEAP) || defined(__DOXYGEN__)
#define CH_USE_HEAP                     TRUE
#endif

#if !defined(CH_USE_MALLOC_HEAP) || defined(__DOXYGEN__)
#define CH_USE_MALLOC_HEAP              FALSE
#endif

#if !defined(CH_USE_MEMPOOLS) || defined(__DOXYGEN__)
#define CH_USE_MEMPOOLS                 TRUE
#endif

#if !defined(CH_USE_DYNAMIC) || defined(__DOXYGEN__)
#define CH_USE_DYNAMIC                  TRUE
#endif

#if !defined(CH_DBG_SYSTEM_STATE_CHECK) || defined(__DOXYGEN__)
#define CH_DBG_SYSTEM_STATE_CHECK       TRUE
#endif

#if !defined(CH_DBG_ENABLE_CHECKS) || defined(__DOXYGEN__)
#define CH_DBG_ENABLE_CHECKS            TRUE
#endif

#if !defined(CH_DBG_ENABLE_ASSERTS) || defined(__DOXYGEN__)
#define CH_DBG_ENABLE_ASSERTS           TRUE
#endif

#if !defined(CH_DBG_ENABLE_TRACE) || defined(__DOXYGEN__)
#define CH_DBG_ENABLE_TRACE             TRUE
#endif

#if !defined(CH_DBG_ENABLE_STACK_CHECK) || defined(__DOXYGEN__)
#define CH_DBG_ENABLE_STACK_CHECK       TRUE
#endif

#if !defined(CH_DBG_FILL_THREADS) || defined(__DOXYGEN__)
#define CH_DBG_FILL_THREADS             TRUE
#endif

#if !defined(CH_DBG_THREADS_PROFILING) || defined(__DOXYGEN__)
#define CH_DBG_THREADS_PROFILING        TRUE
#endif

#if !defined(THREAD_EXT_FIELDS) || defined(__DOXYGEN__)
#define THREAD_EXT_FIELDS                                                   \
  /* Add threads custom fields here.*/
#endif

#if !defined(THREAD_EXT_INIT_HOOK) || defined(__DOXYGEN__)
#define THREAD_EXT_INIT_HOOK(tp) {                                          \
  /* Add threads initialization code here.*/                                \
}
#endif

#if !defined(THREAD_EXT_EXIT_HOOK) || defined(__DOXYGEN__)
#define THREAD_EXT_EXIT_HOOK(tp) {                                          \
  /* Add threads finalization code here.*/                                  \
}
#endif

#if !defined(THREAD_CONTEXT_SWITCH_HOOK) || defined(__DOXYGEN__)
#define THREAD_CONTEXT_SWITCH_HOOK(ntp, otp) {                              \
  /* System halt code here.*/                                               \
}
#endif

#if !defined(IDLE_LOOP_HOOK) || defined(__DOXYGEN__)
#define IDLE_LOOP_HOOK() {                                                  \
  /* Idle loop code here.*/                                                 \
}
#endif

#if !defined(SYSTEM_TICK_EVENT_HOOK) || defined(__DOXYGEN__)
#define SYSTEM_TICK_EVENT_HOOK() {                                          \
  /* System tick event code here.*/                                         \
}
#endif

#if !defined(SYSTEM_HALT_HOOK) || defined(__DOXYGEN__)
#define SYSTEM_HALT_HOOK() {                                                \
  /* System halt code here.*/                                               \
}
#endif

#endif  /* _CHCONF_H_ */
