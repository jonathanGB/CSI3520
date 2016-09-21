; CSI 3520 Devoir 1 Question 1
; Nom de l'élève : Jonathan Guillotte-Blouin
; Nombre d'étudiants : 7900293
; Courriel d’étudiant: jguil098@uottawa.ca

(define (heapsort l)
  (let* ((count (length l)) (endIndex (- count 1)) (heap (heapify l count)))
    (letrec ((whilePositive (lambda (i arr)
      (if (> i 0)
        (whilePositive (- i 1) (swap arr i))
        arr
      ))))
      ; recursive call to swap and siftDown
      (whilePositive endIndex heap)
    )
  )
)


(define (swap arr i)
  (begin (write i) arr)
)


(define (heapify l count)
  (display count)
)


(define (siftDown l startIndex endIndex)
  (display startIndex)
)
