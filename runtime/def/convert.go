package def

func Unreachable() {}

func Malloc(bytes int) I8p { return I8p(0) }

func SliceToI8(slice interface{}) I8p { return I8p(0) }

func MemCopy(dst I8p, src I8p, bytes int) {}

func ArrayPtr(src I8p, emBytes int, index int) I8p { return I8p(0) }
