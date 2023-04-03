;domain file for the problem 3.2 of the assigment
;definition of the emergency-service scenario

; ---------------------------------------------------

(define (domain emergency-service-extended)
    (:requirements :strips :typing :conditional-effects :negative-preconditions :disjunctive-preconditions :fluents) 

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
        
        (busy ?r - robot) ; robot is performing non-atomic action
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
    ; fill a single box, if the box is empty and content, box and agent are all at the same location
    (:action fill
        :parameters (?r - robot ?b - box ?c - content ?t - content_type ?l - location)
        :precondition (and 
            (at ?r ?l) (at ?b ?l) (at ?c ?l) (not (busy ?r)) 
            (empty ?b) (available ?c) (instance_of ?c ?t)
            ; fill box only with content that someone needs somewhere
            ; (exists (?p - person) (needs ?p ?t))
            (> (count_needed ?t) 0)
        ) 
        :effect (and (contains ?b ?c) (not (empty ?b)) (not (available ?c)))
    )

    ; NOTE: in this domain emptying is NOT intended as an atomic action (serving one person at a time)
    ; NOTE: we assume that a robot can empty only a box carried by its own carrier
    ; NOTE: we assume the box to be still loaded on the robot after emptying
    ; NOTE: no need to check for position of other locatables since we check they're all attached to each other
    ; empty a box by dropping the content at the current location, and causing the people at the same location to have the content
    (:action empty
        :parameters (?r - robot ?cr - carrier ?b - box ?c - content ?t - content_type ?p - person ?l - location)
        :precondition (and 
            (at ?r ?l) (at ?p ?l) (pulls ?r ?cr) (carries ?cr ?b) 
            (contains ?b ?c) (instance_of ?c ?t) (needs ?p ?t)
            (or (not (busy ?r)) (is_emptying_at ?r ?b ?l))
        )
        :effect (and
            (busy ?r) (is_emptying_at ?r ?b ?l) (not (needs ?p ?t))
            ; "people" is plural, so we assume amount of content in a box is big enough for many people
            ; thus we also assume they will all get the content of the box, if they need it
            ; (forall (?p - person) (when (at ?p ?l) (and (owns ?p ?c) (not (needs ?p ?t)))))
            (decrease (count_needs ?p) 1)
            (decrease (count_needed ?t) 1) 
            (decrease (count_needed_at ?t ?l) 1)
        )
    )

    ; NOTE: in this domain emptying is NOT intended as an atomic action (serving one person at a time)
    ; NOTE: no need to check for position of other locatables since we check they're all attached to each other
    ; NOTE: after emptying, the effect actively changes position of content, since it's not in the box anymore
    ; change status of a box to empty (all people at location were served with content)
    (:action check_empty
        :parameters (?r - robot ?cr - carrier ?b - box ?c - content ?t - content_type ?l - location)
        :precondition (and 
            (at ?r ?l) (pulls ?r ?cr) (carries ?cr ?b) (contains ?b ?c) (instance_of ?c ?t)
            (busy ?r) (is_emptying_at ?r ?b ?l) (= (count_needed_at ?t ?l) 0)
        )
        :effect (and 
            (not (busy ?r)) (not (is_emptying_at ?r ?b ?l)) 
            (empty ?b) (not (contains ?b ?c)) (at ?c ?l)
        )
    )
    
    ; NOTE: no need to check for position of carrier since we check it's pulled by the robot
    ; pick up a single box and load it on the carrier, if it is at the same location as the box
    (:action pickup
        :parameters (?r - robot ?cr - carrier ?b - box ?l - location)
        :precondition (and 
            (at ?r ?l) (at ?b ?l) (not (busy ?r)) (pulls ?r ?cr) 
            (loadable ?b) (< (count_load ?cr) (max_load ?cr))
        )
        :effect (and (carries ?cr ?b) (not (loadable ?b)) (increase (count_load ?cr) 1))
    )

    ; NOTE: no need to change position of other locatables thanks to attached-aware logic
    ; move to another location (no matter if robot has anything attached or not)
    (:action move
        :parameters (?r - robot ?from - location ?to - location)
        :precondition (and (at ?r ?from) (not (busy ?r)))
        :effect (and (not (at ?r ?from)) (at ?r ?to))
    )     

    ; NOTE: no need to check for position of other locatables since we check they're all attached to each other
    ; NOTE: after deliver, the effect actively changes position of box, since it's not on the carrier anymore
    ; NOTE: no explicit mention to deliver only boxes that are full
    ; deliver a box to a specific person who is at the same location
    (:action deliver
        :parameters (?r - robot ?cr - carrier ?b - box ?p - person ?l - location)
        :precondition (and (at ?r ?l) (at ?p ?l) (not (busy ?r)) (pulls ?r ?cr) (carries ?cr ?b))
        :effect (and (at ?b ?l) (loadable ?b) (not (carries ?cr ?b)) (decrease (count_load ?cr) 1))
    )
)


