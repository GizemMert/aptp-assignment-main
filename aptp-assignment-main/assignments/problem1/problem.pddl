(define (problem problem_one) (:domain emergency-service)

(:objects 
    
    b1 b2 - box
    l1 l2 l3 - location
    c1 c2 c3 c4 c5 c6 - content
    gizem daria indira savannah luca - person
)

(:init
    
    (at gizem l1) (needs gizem medicine)
    (at daria l2) (needs daria medicine) (needs daria food)
    (at indira l3) (needs indira tool) (needs indira food)
    (at savannah l3) (needs savannah tool) (needs savannah food) (needs savannah medicine)
    (at luca depot) (safe luca)

    (at b1 depot) (empty b1) (loadable b1) 
    (at b2 depot) (empty b2) (loadable b2)

    (at c1 depot) (available c1) (instance_of c1 food)
    (at c2 depot) (available c2) (instance_of c2 food)
    (at c3 depot) (available c3) (instance_of c3 medicine)
    (at c4 depot) (available c4) (instance_of c4 medicine)
    (at c5 depot) (available c5) (instance_of c5 medicine)
    (at c6 depot) (available c6) (instance_of c6 tool)

    (at agent depot) (free agent)
)

(:goal (and

    ; all people needs are successfully satified
    (forall (?p - person) (safe ?p))

    ;; -----------------------------------------------------------------------
    ;; additional goal: make agent return to depot to be ready for new tasks
    (at agent depot)
))

)