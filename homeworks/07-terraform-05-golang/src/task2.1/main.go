package main

import "fmt"

func main() {
	fmt.Print("Введите количество метров: ")
	var input float64
	fmt.Scanf("%f", &input)
	output := input * 3.28084
	fmt.Print(input, " метр(-а) - это ", output, " футов" )
}
