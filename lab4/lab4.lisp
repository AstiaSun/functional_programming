(defclass word()
((word-content :accessor word-content)
(is-start-from-sylable :accessor is-start-from-sylable)))

(setf sylables (list "b" "c" "d" "f" "g" "h" "j" "k" "l" "m" "n" "p" "q" "r" "s" "t" "v" "w" "x" "z"))

(defmethod get_first_character (word)
	(string-downcase (string (char (word-content word) 0))))

(defun check_if_starts_from_sylable (w)
 (not (eq (find (get_first_character w) sylables :test #'equal) NIL)))

(defmethod print_word((w word) &key)
	(print (slot-value w 'content)))

(defmethod compare_word((w1 word) (w2 word) &key)
	(equal (slot-value w1 'content) (slot-value w2 'content)))

(defun printer (bag-of-words)
	(loop for word in bag-of-words do
		(format t "~D <==> ~:S ~%" (word-content word) (vowels-part word))))

(defun find_word(lst1 lst2)
(if (nil lst1) ()
(if (member (car lst1) lst2 :test #'compare_word)
(find_word (cdr lst1) lst2)
(car lst1))))

(defun replace-all (string part replacement &key (test #'char=))
  "Returns a new string in which all the occurences of the part 
is replaced with replacement."
  (with-output-to-string (out)
    (loop with part-length = (length part)
          for old-pos = 0 then (+ pos part-length)
          for pos = (search part string
                            :start2 old-pos
                            :test test)
          do (write-string string out
                           :start old-pos
                           :end (or pos (length string)))
          when pos do (write-string replacement out)
          while pos)))

(defun split_to_words (string)
(setf word-bag '())
(setf new-string (replace-all string "." ""))
(setf new-string (replace-all new-string "," ""))
(loop for i = 0 then (1+ j) as j = (position #\Space new-string :start i)
	do
		(setf word (make-instance 'word))
		(setf _place (subseq new-string i j))
		(setf (word-content word) _place)
		(setf (is-start-from-sylable word) (check_if_starts_from_sylable word))
		;(format t "~S ~D~%" (word-content word) (is-start-from-sylable word))
		(push word word-bag)
	while j)
word-bag)

(defun delete_words_which_starts_from_sylable_by_length (bag-of-words word_length)
	(format t "~S~%" "Deleted words:")
	(setf new-word-bag '())
	(loop for word in bag-of-words do
	(if (not (and (eq (length (word-content word)) word_length) (eq (is-start-from-sylable word) T)))
		(push word new-word-bag) (format t "~S " (word-content word))))
	(format t "~%"))

(defmethod print_words (bag-of-words)
	(loop for word in bag-of-words do (format t "~S " (word-content word)))
	(format t "~%"))

(setf text "He share of first to worse. Weddings and any opinions suitable smallest nay. My he houses or months settle remove ladies appear. Engrossed suffering supposing he recommend do eagerness. Commanded no of depending extremity recommend attention tolerably. Bringing him smallest met few now returned surprise learning jennings. Objection delivered eagerness he exquisite at do in. Warmly up he nearer mr merely me.") 
(format t "~S~%" text)
(setf bag-of-words (split_to_words text))
(delete_words_which_starts_from_sylable_by_length bag-of-words 5)