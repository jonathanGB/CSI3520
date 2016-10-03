; CSI 3520 Devoir 1 Question 1
; Nom de l'élève : Jonathan Guillotte-Blouin
; Nombre d'étudiants : 7900293
; Courriel d’étudiant: jguil098@uottawa.ca

(define (list-elem arr i)
  (letrec ((list-elem-rec (lambda (arr i currIndex)
    (if (= i currIndex)
      (car arr)
      (list-elem-rec (cdr arr) i (+ currIndex 1))
    ))))
    (list-elem-rec arr i 0)
  )
)

(define (swap arr i j)
  (let ((iVal (list-elem arr i)) (jVal (list-elem arr j)))
    (letrec ((swap-rec (lambda (currIndex crawledList currList)
      (cond
        ((null? crawledList) currList)
        ((= currIndex i) (swap-rec (+ currIndex 1) (cdr crawledList) (append currList (list jVal))))
        ((= currIndex j) (swap-rec (+ currIndex 1) (cdr crawledList) (append currList (list iVal))))
        (else (swap-rec (+ currIndex 1) (cdr crawledList) (append currList (list (car crawledList)))))
      ))))
      (swap-rec 0 arr '())
    )
  )
)



(define (heapsort l)
  (let* ((count (length l)) (endIndex (- count 1)) (heap (heapify l count)))
    (letrec ((whilePositive (lambda (i arr)
      (if (> i 0)
        (whilePositive (- i 1) (siftDown (swap arr i 0) 0 (- i 1)))
        arr
      ))))
      ; recursive call to swap and siftDown
      (whilePositive endIndex heap)
    )
  )
)


(define (heapify l count)
  (let ((endIndex (- count 1)) (parentIndex (lambda (x)
    (floor (/ (- x 1) 2))
    )))
    (letrec ((whileNonNegative (lambda (startIndex arr)
      (if (>= startIndex 0)
        (whileNonNegative (- startIndex 1) (siftDown arr startIndex endIndex))
        arr
      ))))
      (whileNonNegative (parentIndex endIndex) l)
    )
  )
)


(define (siftDown l startIndex endIndex)
  (let ((leftChildIndex (lambda (x) (+ (* 2 x) 1))) (rightChildIndex (lambda (x) (+ (* 2 x) 2))))
    (letrec ((while (lambda (rootIndex arr)
      (let ((childIndex (leftChildIndex rootIndex)) (swapIndex rootIndex))
        (if (<= childIndex endIndex)
          (begin
            (if (< (list-elem arr swapIndex) (list-elem arr childIndex))
              (set! swapIndex childIndex)
              #f
            )
            (if (and (<= (+ childIndex 1) endIndex) (< (list-elem arr swapIndex) (list-elem arr (+ childIndex 1))))
              (set! swapIndex (+ childIndex 1))
              #f
            )
            (if (not (eq? swapIndex rootIndex))
              (while swapIndex (swap arr rootIndex swapIndex))
              arr
            )
          )
          arr
        )
      ))))
      (while startIndex l)
    )
  )
)
