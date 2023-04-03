;domain file for the problem 3.1 of the assigment
;definition of the emergency-service scenario

; ---------------------------------------------------

(define (domain emergency-service)
    (:requirements :strips :typing :conditional-effects :negative-preconditions) 

    (:types 

        location locatable content_type - object
        owner robot content - locatable
        person box - owner
    ) 

    (:constants
        
        agent - robot
        depot - location
        food medicine tool - content_type
    )

    (:predicates
        
        (at ?o - locatable ?l - location) ; locatable object is at location
        (owns ?o - owner ?c - content) ; owner (person or box) owns the content
        (needs ?p - person ?t - content_type) ; person needs content of given type
        (instance_of ?c - content ?t - content_type) ; content is instance of given type
        (carries ?r - robot ?b - box) ; robot is carrying the box
        
        (safe ?p - person) ; all person's needs are satisfied
        (free ?r - robot) ; robot is not carrying any boxes
        (empty ?b - box) ; box is empty (has no contents)
        (loadable ?b - box) ; box can be loaded (no robot has loaded it yet)
        (available ?c - content) ; content can be picked up
    )

    ; NOTE: we assume the robot might fill a box without picking it up
    ; fill a single box, if the box is empty and content, box and agent are all at the same location
    (:action fill
        :parameters (?r - robot ?b - box ?c - content ?t - content_type ?l - location)
        :precondition (and 
            (at ?r ?l) (at ?b ?l) (at ?c ?l) (empty ?b) (available ?c) (instance_of ?c ?t)
            ; fill box only with content that someone needs
            (exists (?p - person) (needs ?p ?t))
        ) 
        :effect (and (owns ?b ?c) (not (empty ?b)) (not (available ?c)))
    )

    ; NOTE: seems reasonable to assume that a robot can empty only the box it carries
    ; NOTE: we also assume the box to be still loaded on the robot after emptying
    ; empty a box by dropping the content at the current location, and causing the people at the same location to have the content
    (:action empty
        :parameters (?r - robot ?b - box ?c - content ?t - content_type ?l - location)
        :precondition (and 
            (at ?r ?l) (at ?b ?l) (at ?c ?l) (carries ?r ?b) (owns ?b ?c) (instance_of ?c ?t)
            ; empty box at location only if content is needed by someone there
            (exists (?p - person) (and (at ?p ?l) (needs ?p ?t))) 
        )
        :effect (and
            (empty ?b) (not (owns ?b ?c))
            ; people is plural, so we assume amount of content in a box is big enough for many people
            ; thus we also assume they will all get the content of the box, if they need it
            (forall (?p - person) (when (at ?p ?l) (and (owns ?p ?c) (not (needs ?p ?t)))))
        )
    )

    ; pick up a single box and load it on the robotic agent, if it is at the same location as the box (when box is empty)
    (:action pickup_empty
        :parameters (?r - robot ?b - box ?l - location)
        :precondition (and (at ?r ?l) (at ?b ?l) (free ?r) (loadable ?b) (empty ?b))
        :effect (and (carries ?r ?b) (not (free ?r)) (not (loadable ?b)))
    )

    ; pick up a single box and load it on the robotic agent, if it is at the same location as the box (when box is full)
    (:action pickup_full
        :parameters (?r - robot ?b - box ?c - content ?t - content_type ?l - location)
        :precondition (and 
            (at ?r ?l) (at ?b ?l) (at ?c ?l) (free ?r) (loadable ?b) (owns ?b ?c) (instance_of ?c ?t)
            ; pick up a full box only if its content is needed by someone
            (exists (?p - person) (needs ?p ?t)) 
        )
        :effect (and (carries ?r ?b) (not (free ?r)) (not (loadable ?b)))
    )

    ; move to another location (if no box has been loaded)
    (:action move_free
        :parameters (?r - robot ?from - location ?to - location)
        :precondition (and (at ?r ?from) (free ?r))
        :effect (and (not (at ?r ?from)) (at ?r ?to))
    )  

    ; move to another location (if a box has been loaded and it's empty)
    (:action move_loaded_empty
        :parameters (?r - robot ?b - box ?from - location ?to - location)
        :precondition (and (at ?r ?from) (at ?b ?from) (carries ?r ?b) (empty ?b))
        :effect (and 
            (not (at ?r ?from)) (at ?r ?to) 
            (not (at ?b ?from)) (at ?b ?to)
        )
    )

    ; move to another location (if a box has been loaded and it's full)
    (:action move_loaded_full
        :parameters (?r - robot ?b - box ?c - content ?from - location ?to - location)
        :precondition (and (at ?r ?from) (at ?b ?from) (at ?c ?from) (carries ?r ?b) (owns ?b ?c))
        :effect (and 
            (not (at ?r ?from)) (at ?r ?to) 
            (not (at ?b ?from)) (at ?b ?to) 
            (not (at ?c ?from)) (at ?c ?to)
        )
    )     

    ; NOTE: no explicit mention to deliver only boxes that are full

    ; deliver a box to a specific person who is at the same location (when box is empty)
    (:action deliver_empty
        :parameters (?r - robot ?b - box ?p - person ?l - location)
        :precondition (and (at ?r ?l) (at ?b ?l) (at ?p ?l) (carries ?r ?b) (empty ?b))
        :effect (and (free ?r) (loadable ?b) (not (carries ?r ?b)))
    )

    ; deliver a box to a specific person who is at the same location (when box is full)
    (:action deliver_full
        :parameters (?r - robot ?b - box ?c - content ?p - person ?l - location)
        :precondition (and (at ?r ?l) (at ?b ?l) (at ?c ?l) (at ?p ?l) (carries ?r ?b) (owns ?b ?c))
        :effect (and (free ?r) (loadable ?b) (not (carries ?r ?b)))
    )

    ; change status of a person to safe whenever all needs are satisfied
    (:action check_safe
        :parameters (?p - person)
        :precondition (and (not (safe ?p)) (not (exists (?t - content_type) (needs ?p ?t))))
        :effect (and (safe ?p))
    )
)


