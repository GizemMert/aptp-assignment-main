;domain file for the problem 3.5 of the assigment
;definition of the extended emergency-service scenario

; ---------------------------------------------------

(define (domain emergency-service-extended-durative)
    (:requirements :strips :typing :fluents :durative-actions) 

    (:types 

        location locatable content_type - object
        person box robot carrier content - locatable
    ) 

    (:constants
        
        agent - robot
        depot - location
        food medicine tool - content_type
    )

    (:predicates
        
        (at ?o - locatable ?l - location) ; locatable object is at location
        (contains ?b - box ?c - content) ; box contains the content
        (needs ?p - person ?t - content_type) ; person needs content of given type
        (instance_of ?c - content ?t - content_type) ; content is instance of given type
        (pulls ?r - robot ?cr - carrier) ; robot is pulling the carrier
        (carries ?cr - carrier ?b - box) ; carrier is carrying the box
        (is_emptying_at ?r - robot ?b - box ?l - location) ; robot is emptying box at given location
        
        (safe ?p - person) ; all person's needs are satisfied
        (not_busy ?r - robot) ; robot is not performing any action at the moment
        (empty ?b - box) ; box is empty (has no contents)
        (loadable ?b - box) ; box can be loaded (no robot has loaded it yet)
        (available ?c - content) ; content can be picked up (not contained in a box)
    )

    (:functions
        
        (max_load ?cr - carrier) ; FIXED: max boxes allowed for a given carrier
        (count_load ?cr - carrier) ; COUNTER: boxes loaded on the carrier
        (count_needs ?p - person) ; COUNTER: content types needed by a given person
        (count_needed ?t - content_type) ; COUNTER: people who need a given content type
        (count_needed_at ?t - content_type ?l - location) ; COUNTER: people who need a given content type at a specific location
    )

    ; NOTE: we assume the robot might fill a box even if it's not loaded
    ; NOTE: this design allows the robot to fill en empty box loaded by another robot
    ; fill a single box, if the box is empty and content, box, and the agent are all at the same location
    (:durative-action fill
        :parameters (?r - robot ?b - box ?c - content ?t - content_type ?l - location)
        :duration (= ?duration 3)
        :condition (and 
            (over all (at ?r ?l))
            (over all (at ?b ?l))
            (over all (at ?c ?l))
            (at start (not_busy ?r))
            (at start (empty ?b)) 
            (at start (available ?c))
            (over all (instance_of ?c ?t))
            (at start (> (count_needed ?t) 0))
        ) 
        :effect (and 
            (at start (not (not_busy ?r)))
            (at end (not_busy ?r))
            (at end (contains ?b ?c))
            (at end (not (empty ?b)))
            (at start (not (available ?c)))
        )
    )

    ; NOTE: it is assumed that the robot can only empty a box carried by its own carrier
    ; NOTE: we assume the box to be still loaded on the robot after emptying
    ; empty a box by releasing its contents at the current location, and causing the people at the same location to have the content
    (:durative-action start_empty
        :parameters (?r - robot ?cr - carrier ?b - box ?c - content ?t - content_type ?p - person ?l - location)
        :duration (= ?duration 3)
        :condition (and 
            (over all (at ?r ?l))
            (over all (at ?p ?l))
            (over all (pulls ?r ?cr))
            (over all (carries ?cr ?b))
            (over all (contains ?b ?c))
            (over all (instance_of ?c ?t))
            (at start (needs ?p ?t))
            (at start (not_busy ?r))
            (at start (> (count_needed_at ?t ?l) 0))
        )
        :effect (and 
            (at start (not (not_busy ?r)))
            ; (at end (not (not_busy ?r))) ; robot will still be busy at end
            (at start (is_emptying_at ?r ?b ?l))
            ; (at end (is_emptying_at ?r ?b ?l)) ; robot will still be emptying at that location at end
            (at start (not (needs ?p ?t)))
            (at end (decrease (count_needs ?p) 1))
            (at end (decrease (count_needed ?t) 1))
            (at end (decrease (count_needed_at ?t ?l) 1))
        )   
    )

    ; NOTE: it is assumed that the robot can only empty a box carried by its own carrier
    ; NOTE: we assume the box to be still loaded on the robot after emptying
    ; empty a box by releasing its contents at the current location, and causing the people at the same location to have the content
    (:durative-action continue_empty
        :parameters (?r - robot ?cr - carrier ?b - box ?c - content ?t - content_type ?p - person ?l - location)
        :duration (= ?duration 3)
        :condition (and 
            (over all (at ?r ?l))
            (over all (at ?p ?l))
            (over all (pulls ?r ?cr))
            (over all (carries ?cr ?b))
            (over all (contains ?b ?c))
            (over all (instance_of ?c ?t))
            (at start (needs ?p ?t))
            (at start (is_emptying_at ?r ?b ?l)) ; not (not_busy ?r) inferred 
            (at start (> (count_needed_at ?t ?l) 0))
        )
        :effect (and 
            ; (at end (not (not_busy ?r))) ; robot will still be busy at end
            ; (at end (is_emptying_at ?r ?b ?l)) ; robot will still be emptying at that location at end
            (at start (not (needs ?p ?t)))
            (at end (decrease (count_needs ?p) 1))
            (at end (decrease (count_needed ?t) 1))
            (at end (decrease (count_needed_at ?t ?l) 1))
        )   
    )
    
    ; NOTE: no need to check for position of other locatables since we check they're all attached to each other
    ; NOTE: after emptying, the effect actively changes position of content, since it's not in the box anymore
    ; change status of a box to empty (all people at location were served with content)
    (:durative-action check_empty
        :parameters (?r - robot ?cr - carrier ?b - box ?c - content ?t - content_type ?l - location)
        :duration (= ?duration 1)
        :condition (and 
            (over all (at ?r ?l))
            (over all (pulls ?r ?cr))
            (over all (carries ?cr ?b))
            (over all (contains ?b ?c))
            (over all (instance_of ?c ?t))
            (at start (is_emptying_at ?r ?b ?l)) ; not (not_busy ?r) inferred
            (at start (= (count_needed_at ?t ?l) 0))
        )
        :effect (and 
            (at end (not_busy ?r))
            (at start (not (is_emptying_at ?r ?b ?l)))
            (at end (not (contains ?b ?c)))
            (at end (empty ?b))
            (at end (at ?c ?l))
        )
    ) 

    ; NOTE: no need to check for position of carrier since we check it's pulled by the robot
    ; pick up a single box and load it on the carrier, if it is at the same location as the box
    (:durative-action pickup
        :parameters (?r - robot ?cr - carrier ?b - box ?l - location)
        :duration (= ?duration 2)
        :condition (and 
            (over all (at ?r ?l))
            (over all (at ?b ?l))
            (over all (pulls ?r ?cr))
            (at start (not_busy ?r))
            (at start (loadable ?b))
            (at start (< (count_load ?cr) (max_load ?cr)))
        )
        :effect (and 
            (at start (not (not_busy ?r)))
            (at end (not_busy ?r))
            (at start (not (loadable ?b)))
            (at end (carries ?cr ?b))
            (at end (increase (count_load ?cr) 1))
        )
    ) 

    ; NOTE: no need to change position of other locatables thanks to attached-aware logic
    ; move to another location (no matter if robot has anything attached or not)
    (:durative-action move
        :parameters (?r - robot ?from - location ?to - location)
        :duration (= ?duration 5)
        :condition (and 
            (at start (at ?r ?from))
            (at start (not_busy ?r))
        )
        :effect (and 
            (at start (not (not_busy ?r)))
            (at end (not_busy ?r))
            (at start (not (at ?r ?from)))
            (at end (at ?r ?to))
        )
    ) 

    ; NOTE: no need to check for position of other locatables since we check they're all attached to each other
    ; NOTE: after deliver, the effect actively changes position of box, since it's not on the carrier anymore
    ; NOTE: no explicit mention to deliver only boxes that are full
    ; deliver a box to a specific person who is at the same location
    (:durative-action deliver
        :parameters (?r - robot ?cr - carrier ?b - box ?p - person ?l - location)
        :duration (= ?duration 2)
        :condition (and 
            (over all (at ?r ?l))
            (over all (at ?p ?l))
            (at start (not_busy ?r))
            (over all (pulls ?r ?cr))
            (at start (carries ?cr ?b))
        )
        :effect (and 
            (at start (not (not_busy ?r)))
            (at end (not_busy ?r))
            (at end (at ?b ?l))
            (at end (loadable ?b))
            (at end (not (carries ?cr ?b)))
            (at end (decrease (count_load ?cr) 1))
        )
    )

    ; change status of a person to safe whenever all needs are satisfied
    (:durative-action check_safe
        :parameters (?r - robot ?p - person)
        :duration (= ?duration 1)
        :condition (and 
            (at start (not_busy ?r))
            (at start (= (count_needs ?p) 0))
        )
        :effect (and 
            (at start (not (not_busy ?r)))
            (at end (not_busy ?r))
            (at end (safe ?p))
        )
    )
)