/*
 * LED-Cube configuration - Copyright (C) 2014 Nick Schrader
 */

#define N_COLUMNS 64
#define N_LAYERS 8
#define LAYER_DATA_TYPE uint64_t
#define BYTES_PER_LAYER sizeof(LAYER_DATA_TYPE)
#define DELAY_PER_LAYER 2

#define FOREACH(x, y) {uint8_t i; for(i = 0; i < y; i++) {x;}}
#define FOREACH_COLUMN(x) FOREACH(x, N_COLUMNS)
#define FOREACH_LAYER(x) FOREACH(x, N_LAYERS)


struct pin {
  GPIO_TypeDef *port;
  uint8_t pad;
};

/* 
 * Do not use A11, A12, B6, B7, E0, E1, E2, E3, E4, E5, F0, F1
 */

static const struct pin column[N_COLUMNS] = {
  {GPIOD, 2},	//0
  {GPIOB, 5},	//1
  {GPIOD, 0},	//2
  {GPIOD, 7},	//3
  {GPIOC, 11},	//4
  {GPIOB, 3},	//5
  {GPIOA, 15},	//6
  {GPIOD, 6},	//7
  {GPIOA, 14},	//8
  {GPIOD, 1},	//9
  {GPIOC, 10},	//10
  {GPIOD, 4},	//11
  {GPIOC, 12},	//12
  {GPIOC, 9},	//13
  {GPIOD, 5},	//14
  {GPIOA, 13},	//15
  {GPIOB, 4},	//16
  {GPIOA, 3},	//17
  {GPIOA, 9},	//18
  {GPIOF, 4},	//19
  {GPIOA, 5},	//20
  {GPIOA, 1},	//21
  {GPIOC, 13},	//22
  {GPIOC, 3},	//23
  {GPIOC, 8},	//24
  {GPIOB, 8}, 	//25
  {GPIOA, 8},	//26
  {GPIOF, 10},	//27
  {GPIOF, 6},	//28
  {GPIOA, 10},	//29
  {GPIOC, 1},	//30
  {GPIOC, 15},	//31
  {GPIOE, 12},	//32
  {GPIOC, 7},	//33
  {GPIOE, 13},	//34
  {GPIOD, 14},	//35
  {GPIOE, 10},	//36
  {GPIOD, 12},	//37
  {GPIOE, 11},	//38
  {GPIOB, 0},	//39
  {GPIOA, 4},	//40
  {GPIOE, 7},	//41
  {GPIOC, 5},	//42
  {GPIOB, 2},	//43
  {GPIOC, 4},	//44
  {GPIOE, 9},	//45
  {GPIOB, 1},	//46
  {GPIOE, 8}, 	//47
  {GPIOD, 3},	//48
  {GPIOD, 10},	//49
  {GPIOC, 6},	//50
  {GPIOD, 8},	//51
  {GPIOD, 15},	//52
  {GPIOB, 14},	//53
  {GPIOD, 13},	//54
  {GPIOB, 12},	//55
  {GPIOE, 15},	//56
  {GPIOB, 13},	//57
  {GPIOE, 14},	//58
  {GPIOB, 15},	//59
  {GPIOB, 10},	//60
  {GPIOD, 9},	//61
  {GPIOB, 11},	//62
  {GPIOD, 11},	//63
};

static const struct pin layer[N_LAYERS] = {
  {GPIOC, 14},	//0
  {GPIOA, 6},	//1
  {GPIOF, 9},	//2
  {GPIOE, 6},	//3
  {GPIOA, 0},	//4
  {GPIOF, 2},	//5
  {GPIOC, 2},	//6
  {GPIOC, 0},	//7
};

