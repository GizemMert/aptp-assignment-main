(define (problem problem_four) (:domain emergency-service-extended-durative)
    (:objects 
        
        cr1 - carrier
        b1 - box ;b2 b3 b4
        l1 l2 - location ;l3
        c1 c3 c4 - content ;c2 c5 c6
        gizem daria - person ;indira savannah luca
    )

    (:init
        
        ; PEOPLE 
        (at gizem l1) (needs gizem medicine) (= (count_needs gizem) 1)
        (at daria l2) (needs daria medicine) (needs daria food) (= (count_needs daria) 2)
        ;(at indira l3) (needs indira tool) (needs indira food) (= (count_needs indira) 2)
        ;(at savannah l3) (needs savannah tool) (needs savannah food) (needs savannah medicine) (= (count_needs savannah) 3)
        ;(at luca depot) (= (count_needs luca) 0)

        ; NEED COUNTERS
        (= (count_needed medicine) 3)
        (= (count_needed food) 3)
        (= (count_needed tool) 2)

        (= (count_needed_at medicine l1) 1)
        (= (count_needed_at medicine l2) 1)
        (= (count_needed_at food l2) 1)
        ;(= (count_needed_at medicine l3) 1)
        ;(= (count_needed_at tool l3) 2)
        ;(= (count_needed_at food l3) 2)
        
        ; BOXES
        (at b1 depot) (empty b1) (loadable b1) 
        ;(at b2 depot) (empty b2) (loadable b2)
        ;(at b3 depot) (empty b3) (loadable b3)
        ;(at b4 depot) (empty b4) (loadable b4)

        ; CONTENTS
        (at c1 depot) (available c1) (instance_of c1 food)
        ;(at c2 depot) (available c2) (instance_of c2 food)
        (at c3 depot) (available c3) (instance_of c3 medicine)
        (at c4 depot) (available c4) (instance_of c4 medicine)
        ;(at c5 depot) (available c5) (instance_of c5 medicine)
        ;(at c6 depot) (available c6) (instance_of c6 tool)

        ; CARRIERS
        (at cr1 depot) (= (count_load cr1) 0) (= (max_load cr1) 4)

        ; ROBOTS
        (at agent depot) (pulls agent cr1) (not_busy agent)
    )

    ;every person gets what they need and they dont need anymore
    (:goal (and
        (safe gizem)
        (safe daria)
        ;(safe indira)
        ;(safe savannah)
        ;(safe luca)

        ;; -----------------------------------------------------------------------
        ;; additional goal: make agent return to depot to be ready for new tasks
        (at agent depot)
    )
    )
)

