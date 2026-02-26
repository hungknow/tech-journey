package models

type BinaryTreeNode[T any] struct {
	Val   T
	Left  *BinaryTreeNode[T]
	Right *BinaryTreeNode[T]
}

func BuildBinaryTreeFromIntArray(vals []interface{}) *BinaryTreeNode[int] {
	if len(vals) == 0 {
		return nil
	}

	root := &BinaryTreeNode[int]{
		Val:   vals[0].(int),
		Left:  nil,
		Right: nil,
	}
	queues := []*BinaryTreeNode[int]{root}
	valIndex := 1
	valsLen := len(vals)

	// iterate all items in queue
	for len(queues) > 0 && valIndex < valsLen {
		// Dequeue
		currentNode := queues[0]
		queues = queues[1:]

		// check left
		if valIndex < valsLen {
			if vals[valIndex] != nil {
				currentNode.Left = &BinaryTreeNode[int]{Val: vals[valIndex].(int)}
				queues = append(queues, currentNode.Left)
			}
			valIndex++
		}

		// check right
		if valIndex < valsLen {
			if vals[valIndex] != nil {
				currentNode.Right = &BinaryTreeNode[int]{Val: vals[valIndex].(int)}
				queues = append(queues, currentNode.Right)
			}
			valIndex++
		}

	}

	return root
}
