(load "~/Documents/functional_programming/lab3/ltk/ltk.lisp")
(in-package :ltk)

(deftype size '(member :big :regular :small :tiny))

(defclass Toy ()                           ; Toy baseclass
  ((name :accessor toy-name)
   (size :type size :accessor toy-size)
   (price  :accessor toy-price)
   (age-from :accessor age-from)
   (age-to :accessor age-to)
   (description :accessor toy-description)
  )
)

(defmethod toy-constructor ((object Toy) name size price age-from age-to description)
  (setf (toy-name object) name)
  (setf (toy-size object) size)
  (setf (toy-price object) price)
  (setf (age-from object) age-from)
  (setf (age-to object) age-to)
  (setf (toy-description object) description)
)

(setf super-empty (make-instance 'Toy))
(toy-constructor super-empty "Empty" 0 0 :tiny 0 "")

(defclass Doll (Toy)                        
  (
    (hair-color  :accessor doll-hair-color)
    (skin-color :accessor doll-skin-color)
  )
)

(defmethod describeDoll ((doll Doll) hair-color skin-color)
  (setf (doll-skin-color doll) skin-color)
  (setf (doll-hair-color doll) hair-color)
)

(defclass Machine(Toy)
  (
    (is-automated :accessor is-machine-automated)
    (color :accessor machine-color)
  )
)

(defmethod describeMachine ((machine Machine) is-automated color)
  (setf (is-machine-automated machine) is-automated)
  (setf (machine-color machine) color)
)

(defclass Ball(Toy)
  (
    (color :accessor ball-collor)
  )
)

(defmethod describeBall((ball Ball) color)
  (setf (ball-collor ball) color)
)

(defclass Constructor(Toy)
  (
    (amount-of-elements :accessor constructor-amount-of-elements)))

(defmethod describeConstructor ((constructor Constructor) amount-of-elements)
  (setf (constructor-amount-of-elements constructor) amount-of-elements))

(defclass Room()
  (
    (toys :type list :accessor room-toys)
    (target-price :accessor room-price)))

(defmethod createRoom((room Room) toys target-price)
  (setf (room-toys room) toys)
  (setf (room-price room) target-price))

(defmethod onAddToy((room Room) toy)
  (nconc (room-toys room) (list toy)))

(defmethod fullPrice (toys)
  (if (eq toys nil) (return-from fullPrice 0)) 
  (+ (toy-price (first toys))
    (fullPrice (rest toys))))

(defmethod mapToysToPriceVector(toys)
  (if (eq toys nil)
    (return-from mapToysToPriceVector nil))
  (nconc (list (toy-price (first toys))) (mapToysToPriceVector (rest toys))))

(defmethod onSortByPrice ((room Room))
  (setf prices (mapToysToPriceVector (room-toys room)))
  (sort prices #'<)
  (print prices)
  (format t "ok~%"))

(defmethod sortToysByPrice (toys)
  (setf prices (mapToysToPriceVector toys))
  (sort prices #'<)
  (loop for p in prices do
    (loop for toy in toys do
      (if (eq (toy-price toy) p) (format t "~S~% ~D~%" (toy-name toy) p))))
  ;(print prices)
  (format t "ok~%"))

(defmethod checkBoundaries((toy Toy) from to)
  (if (and (> (toy-price toy) from) )
          (< (toy-price toy) to) )
    (format t "The toy:  ~S~%and his price:~D~%" (toy-name toy) (toy-price toy)))

(defmethod printBounded ((room Room) from to)
  (loop for toy in (room-toys room)
    do (checkBoundaries toy from to)))

(defmethod onCalculate ((room Room) label text_)
  (setf (text label) (write-to-string (fullPrice (room-toys room))))
  (onSortByPrice room)
  (printBounded room 5 35))

(setf empty-room (make-instance 'Room))
(createRoom empty-room nil 0)

(defmethod readToyFromFile((toy Toy) *file*)
  (toy-constructor toy (read *file*) (read *file*) (read *file*) (read *file*) (read *file*) (read *file*)))

(defmethod readDollFromFile(*file*)
  (setf toy (make-instance 'Doll))
  (readToyFromFile toy *file*)
  (describeDoll toy (read *file*) (read *file*))
  (return-from readDollFromFile toy))

(defmethod readBallFromFile(*file*)
  (setf item (make-instance 'Ball))
  (readToyFromFile item *file*)
  (describeDoll item (read *file*) (read *file*))
  (return-from readBallFromFile item))

(defmethod readBallFromFile(*file*)
  (setf item (make-instance 'Ball))
  (readToyFromFile item *file*)
  (describeBall item (read *file*))
  (return-from readBallFromFile item))

(defmethod readMachineFromFile(*file*)
  (setf item (make-instance 'Machine))
  (readToyFromFile item *file*)
  (describeMachine item (read *file*) (read *file*))
  (return-from readMachineFromFile item))

(defmethod readConstructorFromFile(*file*)
  (setf item (make-instance 'Constructor))
  (readToyFromFile item *file*)
  (describeConstructor item (read *file*))
  (return-from readConstructorFromFile item))

(defmethod createDollsFromFile(filename)
  (defparameter *file* (open filename :if-does-not-exist nil))
  (setf dolls nil)
  (setf count (read *file*))
  (loop for x from 1 to count
    do 
    (setf doll (readDollFromFile *file*))
    (if (eq dolls nil) (setf dolls (list doll)) (nconc dolls (list doll))))
  (close *file*)
  (return-from createDollsFromFile dolls))

(defmethod createBallsFromFile(filename)
  (defparameter *file* (open filename :if-does-not-exist nil))
  (setf balls nil)
  (setf count (read *file*))
  (loop for x from 1 to count
    do 
    (setf ball (readBallFromFile *file*))
    (if (eq balls nil) (setf balls (list ball)) (nconc balls (list ball))))
  (close *file*)
  (return-from createBallsFromFile balls))

(defmethod createMachinesFromFile(filename)
  (defparameter *file* (open filename :if-does-not-exist nil))
  (setf machines nil)
  (setf count (read *file*))
  (loop for x from 1 to count
    do 
    (setf machine (readMachineFromFile *file*))
    (if (eq machines nil) (setf machines (list machine)) (nconc machines (list machine))))
  (close *file*)
  (return-from createMachinesFromFile machines))


(defmethod createConstructorsFromFile(filename)
  (defparameter *file* (open filename :if-does-not-exist nil))
  (setf constructors nil)
  (setf count (read *file*))
  (loop for x from 1 to count
    do 
    (setf constructor (readConstructorFromFile *file*))
    (if (eq constructors nil) (setf constructors (list constructor)) (nconc constructors (list constructor))))
  (close *file*)
  (return-from createConstructorsFromFile constructors))

(defmethod createToysFromFile(filename)
  (defparameter *file* (open filename :if-does-not-exist nil))
  (setf toys nil)
  (setf count (read *file*))
  (loop for x from 1 to count
    do 
    (setf toy (make-instance 'Toy))
    (readToyFromFile toy *file*)
    (if (eq toys nil) (setf toys (list toy)) (nconc toys (list toy))))
  (close *file*)
  (return-from createtoysFromFile toys))

(defmethod createToys()
  (setf toys (createToysFromFile "toys"))
  (nconc toys (createDollsFromFile "dolls"))
  (nconc toys (createBallsFromFile "balls"))
  (nconc toys (createMachinesFromFile "machines"))
  (nconc toys (createConstructorsFromFile "constructors")))

(defmethod toysForAge(toys age-from age-to)
  (setf toys-for-age nil)
  (loop for toy in toys do
    (if (and (>= (age-from toy) age-from) 
          (<= (age-to toy) age-to))
      (if (eq toys nil) (setf toys (list toy)) (nconc toys (list toy)))))
  (return-from toysForAge toys))

(defmethod findToy(toys price age-from age-to)
  (loop for toy in toys do
    (print (toy-name toy))
    (if (and (eq (toy-price toy) price) (>= (age-from toy) age-from) (<= (age-to toy) age-to))
      (return-from findToy toy)))
  (return-from findToy super-empty))

(defmethod createRoomForAge (toys age-from age-to price)
  (setf toys-for-room (toysForAge toys age-from age-to))
  (setf room (make-instance 'Room))
  (createRoom room toys-for-age price))

(defmethod getIntegerValue (textfield)
  (parse-integer (text textfield)))

(defmethod printToy (toy)
  (print (toy-name toy)))

(defmethod printAllToys (toys)
  (loop for toy in toys do
    (printToy toy)))

(defmethod printAllRooms(rooms)
  (loop for room in rooms do
    ;(format t "The room has ~D~% toys for children between ~D~% and ~D~%." (length (room-toys room)) (toy-price toy))
    ))

(defun gui ()
  (with-ltk ()
    (setf toys (createToys))
    
    (setf room-for-little (createRoomForAge toys 2 6 1000))

    (setf room-for-big (createRoomForAge toys 7 12 5000))
    

    (setf rooms (list room-for-big room-for-little))

    (let* ((frame_ (make-instance 'frame))
            (text-label-price  (make-instance 'label :master frame_ :text "Price:"))
            (price-entry (make-instance 'entry :master frame_))
            (text-label-age-from (make-instance 'label :master frame_ :text "Age From:"))
            (age-from-entry (make-instance 'entry :master frame_))
            (text-label-age-to (make-instance 'label :master frame_ :text "Age To:"))
            (age-to-entry (make-instance 'entry :master frame_))
            (size-listbox (make-instance 'listbox :master frame_ ))
            (button-find (make-instance 'button :master frame_ :text "Find"
              :command #'(
                lambda () 
                  (listbox-clear size-listbox)
                  (listbox-append size-listbox (toy-name (findToy toys (getIntegerValue price-entry) (getIntegerValue age-from-entry) (getIntegerValue age-to-entry))))
                )
              )
            )
            (button-show-all-toys (make-instance 'button :master frame_ :text "Show All Toys"
              :command #'(
                lambda () 
                  (sortToysByPrice toys)
                )
              )
            )
          )

          ;(listbox-append size-listbox '("Big" "Regular" "Small" "Tiny"))

          (pack frame_ :padx 170 :pady 50)
          (pack text-label-price :padx 20 :pady 3)
          (pack price-entry :padx 20 :pady 3)
          (pack age-from-entry :padx 20 :pady 3)
          (pack age-to-entry :padx 20 :pady 3)
          (pack button-find :padx 20 :pady 3)
          (pack size-listbox :padx 20 :pady 3)
          (pack button-show-all-toys :padx 20 :pady 3)
          (configure frame_ :relief :sunken)
      ()
        ;  (configure btn-leggings :background 0.8)
    )
  )
)

(gui)
