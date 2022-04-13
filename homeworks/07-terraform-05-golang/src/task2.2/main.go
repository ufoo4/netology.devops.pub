package main
 
import (
  "fmt"
  "os"
  "github.com/manifoldco/promptui"
)

var x = []int{48,96,86,68,57,82,63,72,37,34,83,27,19,97,9,17,}

func main() {
	fmt.Print("Программа вычисляет наименьшее число из массива.\n")
	fmt.Print("Массив по умолчанию: ", x, "\n")
	
	if yesNo() == true {
		newArray()
	} else {
		findMin()
	}
}

func yesNo() bool {
    prompt := promptui.Select {
        Label: "Хотите ввести свой массив?",
        Items: []string{"Да", "Нет"},
    }
    _, result, _ := prompt.Run()
    return result == "Да"
}

func findMin() {
	var minElemX = x[0]

	for _, nextElemX := range x {
		if nextElemX < minElemX {
			minElemX = nextElemX
		}
	}
	fmt.Print("Минимальный элемент в дефолтном массиве: ", minElemX)
}

func newArray()  {
  	var size int
  	var array []float64
	var numArray float64
 
 	fmt.Println("Введите размер массива: ")
  	fmt.Fscan(os.Stdin, &size)
 
	for j := 0; j < size; j++ {
		fmt.Println("Введите ", j+1 , " число массива: ")
		fmt.Fscan(os.Stdin, &numArray)
        array = append(array, numArray)
    }
  	fmt.Println("Введенный массив: ", array)
	
	var minElemX = array[0]
	for _, nextElemX := range array {
		if nextElemX < minElemX {
		 minElemX = nextElemX
		}
	}
	fmt.Print("Минимальный элемент в массиве: ", minElemX)
}
