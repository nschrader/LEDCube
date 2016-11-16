/*
 * LED-Cube configuration - Copyright (C) 2014 Nick Schrader
 */

#define N_COLUMNS 4
#define N_LAYERS 2
#define LAYER_DATA_TYPE uint8_t
#define BYTES_PER_LAYER sizeof(LAYER_DATA_TYPE)
#define DELAY_PER_LAYER 8

#define FOREACH(x, y) {uint8_t i; for(i = 0; i < y; i++) {x;}}
#define FOREACH_COLUMN(x) FOREACH(x, N_COLUMNS)
#define FOREACH_LAYER(x) FOREACH(x, N_LAYERS)


struct pin {
  GPIO_TypeDef *port;
  uint8_t pad;
};

static const struct pin column[N_COLUMNS] = {
  {GPIOE, 9},
  {GPIOE, 13},
  {GPIOB, 11},
  {GPIOB, 15},
};

static const struct pin layer[N_LAYERS] = {
  {GPIOD, 11},
  {GPIOD, 15},
};

