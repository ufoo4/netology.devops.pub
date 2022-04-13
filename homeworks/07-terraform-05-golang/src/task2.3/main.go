package main

import "fmt"

func main() {
	numbers := []int{}
	for i := 1; i <= 100; i++ {
		if i % 3 == 0 {
			numbers = append(numbers, i)
		}
	}
	fmt.Print("Числа от 1 до 100, которые делятся на 3 без остатка: \n", numbers)
}