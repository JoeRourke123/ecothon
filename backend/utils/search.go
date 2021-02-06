package utils

func BinarySearch(a []string, search string) bool {
	mid := len(a) / 2
	switch {
	case len(a) == 0:
		return false // not found
	case a[mid] > search:
		return BinarySearch(a[:mid], search)
	case a[mid] < search:
		return BinarySearch(a[mid+1:], search)
	default: // a[mid] == search
		return true // found
	}
}
