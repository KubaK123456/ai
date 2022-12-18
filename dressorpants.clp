
;;;======================================================
;;;   Automotive Expert System
;;;
;;;     This expert system diagnoses some simple
;;;     problems with a car.
;;;
;;;     CLIPS Version 6.3 Example
;;;
;;;     For use with the Auto Demo Example
;;;======================================================

;;; ***************************
;;; * DEFTEMPLATES & DEFFACTS *
;;; ***************************

(deftemplate UI-state
   (slot id (default-dynamic (gensym*)))
   (slot display)
   (slot relation-asserted (default none))
   (slot response (default none))
   (multislot valid-answers)
   (slot state (default middle)))
   
(deftemplate state-list
   (slot current)
   (multislot sequence))
  
(deffacts startup
   (state-list))
   
;;;****************
;;;* STARTUP RULE *
;;;****************

(defrule system-banner ""

  =>
  
  (assert (UI-state (display WelcomeMessage)
                    (relation-asserted start)
                    (state initial)
                    (valid-answers))))

;;;***************
;;;* QUERY RULES *
;;;***************

(defrule determine-query-item ""

   (logical (start))

   =>

   (assert (UI-state (display StartQuestion)
                     (relation-asserted query-item)
                     (response Dress)
                     (valid-answers Dress Pants))))

;;;***************
;;;* DRESS RULES *
;;;***************

(defrule determine-visible-lady-parts ""

   (logical (query-item Dress))

   =>

   (assert (UI-state (display LadyPartsQuestion)
                     (relation-asserted visible-lady-parts)
                     (response No)
                     (valid-answers No Yes))))

(defrule determine-visible-lady-parts-negation ""

   (logical (visible-lady-parts No))

   =>

   (assert (UI-state (display ClassyLady))))

(defrule determine-visible-lady-parts-confirmation ""

   (logical (visible-lady-parts Yes))

   =>

   (assert (UI-state (display LadyPartsConfirmQuestion)
                     (relation-asserted visible-lady-parts-confirm)
                     (response Exactly)
                     (valid-answers Exactly))))

(defrule determine-visible-lady-parts-comment ""

   (logical (visible-lady-parts-confirm Exactly))

   =>

   (assert (UI-state (display SkipDinnerWithParents))))

(defrule determine-fall-past-finger-tips ""

   (logical (query-item Dress))

   =>

   (assert (UI-state (display FallPastFingerTipsQuestion)
                     (relation-asserted falls-past-finger-tips)
                     (response Yes)
                     (valid-answers Yes No))))

(defrule determine-drying-on-high-heat ""

   (logical (query-item Dress))

   =>

   (assert (UI-state (display DryOnHighHeadQuestion)
                     (relation-asserted dried-on-high-heat)
                     (response No)
                     (valid-answers Yes No))))

(defrule determine-bought-in-forever-21 ""

   (logical (dried-on-high-heat Yes))

   =>

   (assert (UI-state (display BoughtInForever21Question)
                     (relation-asserted bought-from-forever-21)
                     (response No)
                     (valid-answers Yes No))))

(defrule determine-taking-a-friend-shopping ""
   (or
      (logical (dried-on-high-heat No))
      (logical (bought-from-forever-21 No))
   )

   =>

   (assert (UI-state (display TakeFriendShopping))))

(defrule determine-sticking-to-subway ""

   (logical (falls-past-finger-tips Yes))

   =>

   (assert (UI-state (display StickingToSubwayQuestion)
                     (relation-asserted sticking-to-subway)
                     (response No)
                     (valid-answers Yes No))))


(defrule determine-is-mid-thigh ""

   (logical (query-item Dress))

   =>

   (assert (UI-state (display IsMidThighQuestion)
                     (relation-asserted is-mid-thigh)
                     (response No)
                     (valid-answers Yes No))))

(defrule determine-is-bare-legged ""

   (logical (is-mid-thigh Yes))

   =>

   (assert (UI-state (display IsBareLeggedQuestion)
                     (relation-asserted is-bare-legged)
                     (response No)
                     (valid-answers Yes No))))

(defrule determine-is-going-to-beach ""

   (logical (is-mid-thigh No))

   =>

   (assert (UI-state (display IsGoingToBeach)
                     (relation-asserted is-going-to-beach)
                     (response No)
                     (valid-answers Yes No))))

(defrule determine-enjoying-sun ""

   (logical (is-going-to-beach Yes))

   =>

   (assert (UI-state (display EnjoyThatSun))))

(defrule determine-is-tube-top ""

   (logical (query-item Dress))

   =>

   (assert (UI-state (display IsTubeTopQuestion)
                     (relation-asserted is-tube-top)
                     (response No)
                     (valid-answers Yes No Maybe))))

(defrule determine-in-doubt ""

   (logical (is-tube-top Maybe))

   =>

   (assert (UI-state (display InDoubt))))

(defrule determine-is-getting-cat-calls ""

   (logical (query-item Dress))

   =>

   (assert (UI-state (display IsGettingCatCalls)
                     (relation-asserted is-getting-cat-calls)
                     (response No)
                     (valid-answers Yes No))))

(defrule determine-is-beyonce-or-lady-gaga ""

   (logical (is-getting-cat-calls Yes))

   =>

   (assert (UI-state (display AreYouFamous)
                     (relation-asserted is-beyonce-or-lady-gaga)
                     (response No)
                     (valid-answers Yes No))))

(defrule determine-we-are-jealous ""

   (logical (is-beyonce-or-lady-gaga Yes))

   =>

   (assert (UI-state (display WeAreJealous))))

(defrule determine-throw-some-make-up ""

   (logical (is-getting-cat-calls No))

   =>

   (assert (UI-state (display ThrowSomeMakeUp))))

(defrule determine-is-avoiding-sewer-grates ""

   (logical (query-item Dress))

   =>

   (assert (UI-state (display IsAvoidingSewerGrates)
                     (relation-asserted is-avoiding-serwer-grates)
                     (response No)
                     (valid-answers Yes No))))

(defrule determine-is-marilyn-monroe ""

   (logical (is-avoiding-serwer-grates Yes))

   =>

   (assert (UI-state (display IsMarilynMonroe)
                     (relation-asserted is-marilyn-monroe)
                     (response No)
                     (valid-answers Yes No))))

(defrule determine-is-doing-walk-of-shame ""

   (logical (is-avoiding-serwer-grates No))

   =>

   (assert (UI-state (display IsDoingWalkOfShame)
                     (relation-asserted is-doing-walk-of-shame)
                     (response Yes)
                     (valid-answers Yes))))

;;;***************
;;;* PANTS RULES *
;;;***************

(defrule determine-see-your-crack ""

   (logical (query-item Pants))

   =>

   (assert (UI-state (display SeeCrackQuestion)
                     (relation-asserted see-your-crack)
                     (response No)
                     (valid-answers No Yes))))
;;;;;;;;
(defrule determine-see-your-crack-negation ""

   (logical (see-your-crack No))

   =>

   (assert (UI-state (display ExcellentCrack))))
;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-see-your-crack-confirmation ""

   (logical (see-your-crack Yes))

   =>

   (assert (UI-state (display BrightLightQuestion)
                     (relation-asserted see-your-crack-confirm)
                     (response Exactly)
                     (valid-answers Exactly))))
;;;;;;;;;;;

(defrule determine-bright-light-exactly ""

   (logical (see-your-crack-confirm Exactly))

   =>

   (assert (UI-state (display NoHonorablePair) (state final))))

;;;;;;;;;;;;;;;;;;;;;

(defrule determine-wear-to-yoga ""

   (logical (query-item Pants))

   =>

   (assert (UI-state (display YogaQuestion)
                     (relation-asserted wear-to-yoga)
                     (response No)
                     (valid-answers No Yes))))
;;;;;;;;;;;;;
(defrule determine-gap-body-or-victoria ""

   (logical (wear-to-yoga No))

   =>

   (assert (UI-state (display GapBodyQuestion)
                     (relation-asserted gap-body-or-victoria)
                     (response No)
                     (valid-answers No))))
;;;;;;;;;;;;
(defrule determine-gap-body-or-victoria-negation ""

   (logical (gap-body-or-victoria No))

   =>

   (assert (UI-state (display PantsPotential) (state final))))
;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;
(defrule determine-going-to-yoga ""

   (logical (wear-to-yoga Yes))

   =>

   (assert (UI-state (display GoingYogaQuestion)
                     (relation-asserted going-to-yoga)
                     (response No)
                     (valid-answers No Yes))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-going-to-yoga-confirmation ""

   (logical (going-to-yoga  Yes))

   =>

   (assert (UI-state (display Namaste))))

;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-going-to-yoga-negation ""

   (logical (going-to-yoga  No))

   =>

   (assert (UI-state (display DownwardDog))))
;;;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-strangers-complimenting ""

   (logical (query-item Pants))

   =>

   (assert (UI-state (display StrangersComplimentingQuestion)
                     (relation-asserted strangers-complimenting)
                     (response No)
                     (valid-answers No Yes))))

;;;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-strangers-complimenting-negation ""

   (logical (strangers-complimenting  No))

   =>

   (assert (UI-state (display Embarasing))))

;;;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-lingerie-model ""

   (logical (strangers-complimenting Yes))

   =>

   (assert (UI-state (display LingerieModelQuestion)
                     (relation-asserted lingerie-model)
                     (response No)
                     (valid-answers No Yes))))
;;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-lingerie-model-negation ""

   (logical (lingerie-model  No))

   =>

   (assert (UI-state (display PutPants) (state final))))

;;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-lingerie-model-confirmation ""

   (logical (lingerie-model  Yes))

   =>

   (assert (UI-state (display CoolJob) (state final))))


;;;;;;;;;;;;;;;;;;;;;
(defrule determine-camel-toe ""

   (logical (query-item Pants))

   =>

   (assert (UI-state (display CamelToeQuestion)
                     (relation-asserted camel-toe)
                     (response No)
                     (valid-answers No Yes Maybe))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-camel-toe-maybe ""

   (logical (camel-toe  Maybe))

   =>

   (assert (UI-state (display NotGoodSign))))
;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-camel-toe-yes ""

   (logical (camel-toe  Yes))

   =>

   (assert (UI-state (display WhatEver))))
;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-camel-toe-no ""

   (logical (camel-toe  No))

   =>

   (assert (UI-state (display ThankGoodness))))
;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-have-pockets ""

   (logical (query-item Pants))

   =>

   (assert (UI-state (display PocketsQuestion)
                     (relation-asserted have-pockets)
                     (response No)
                     (valid-answers No Yes))))
;;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-pockets-painted ""

   (logical (have-pockets Yes))

   =>

   (assert (UI-state (display PaintedPocketsQuestion)
                     (relation-asserted pockets-painted)
                     (response No)
                     (valid-answers No Yes))))
;;;;;;;;;;;;;;
(defrule determine-are-they-slacks ""

   (logical (have-pockets No))

   =>

   (assert (UI-state (display SlacksQuestion)
                     (relation-asserted are-they-slacks)
                     (response No)
                     (valid-answers No Yes))))

;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-are-they-slacks-yes ""

   (logical (are-they-slacks Yes))

   =>

   (assert (UI-state (display LookAtYou)(state final))))
;;;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-are-they-slacks-no ""
   (or
      (logical (pockets-painted Yes)) 
      (logical (are-they-slacks No)) 
   )

   =>

   (assert (UI-state (display SoundSuspect))))

;;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-made-of-denim ""

   (logical (query-item Pants))

   =>

   (assert (UI-state (display DenimQuestion)
                     (relation-asserted made-of-denim)
                     (response No)
                     (valid-answers No Yes))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-is-stretchy ""

   (logical (made-of-denim Yes))

   =>

   (assert (UI-state (display StretchyQuestion)
                     (relation-asserted is-stretchy)
                     (response No)
                     (valid-answers No Yes))))
;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-probably-pants ""
   (or
      (logical (pockets-painted No)) 
      (logical (is-stretchy No)) 
   )

   =>

   (assert (UI-state (display Huzzah)(state final))))

;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-is-stretchy-yes ""
  
      (logical (is-stretchy Yes)) 
   
   =>

   (assert (UI-state (display Jeggins)(state final))))
;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-is-lycra ""

   (logical (made-of-denim No))

   =>

   (assert (UI-state (display LycraQuestion)
                     (relation-asserted is-lycra)
                     (response No)
                     (valid-answers No Yes))))

;;;;;;;;;;;;;;;;;
(defrule determine-are-control-top ""

   (logical (is-lycra Yes))

   =>

   (assert (UI-state (display ControlTopQuestion)
                     (relation-asserted are-control-top)
                     (response No)
                     (valid-answers No Yes))))
;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-are-control-top-yes ""
  
      (logical (are-control-top Yes)) 
   
   =>

   (assert (UI-state (display Gaaah)(state final))))
;;;;;;;;;;;;;;;;;;;;;;;;
(defrule determine-are-control-top-no ""
  
      (or
      (logical (are-control-top No)) 
      (logical (is-lycra No)) 
   )
   
   =>

   (assert (UI-state (display GoodSign)(state final))))


;;;*****************
;;;* DECLARE RULES *
;;;*****************

(defrule declare-no-longer-a-dress ""
   (logical (bought-from-forever-21 Yes))
   
   =>

   (assert (UI-state (display NoLongerDress) (state final))))

(defrule declare-gyno-appointment ""
   (logical (sticking-to-subway Yes))
   
   =>

   (assert (UI-state (display MakeGynoAppointment) (state final))))

(defrule declare-definetly-a-dress ""
   (or
      (logical (sticking-to-subway No))
      (logical (is-bare-legged No))
   )
   
   =>

   (assert (UI-state (display DefinetlyDress) (state final))))

(defrule declare-weaing-tunic ""
   (or
      (logical (is-bare-legged Yes))
      (logical (is-going-to-beach No))
   )
   
   =>

   (assert (UI-state (display WearingTunic) (state final))))

(defrule declare-know-your-clothing ""
   (logical (is-tube-top No))
   
   =>

   (assert (UI-state (display KnowYourClothing) (state final))))

(defrule declare-two-faced-clothing ""
   (logical (is-tube-top Yes))
   
   =>

   (assert (UI-state (display TwoFacedClothing) (state final))))

(defrule declare-weaing-lingerie ""
   (logical (is-beyonce-or-lady-gaga No))
   
   =>

   (assert (UI-state (display WearingLingerie) (state final))))

(defrule declare-not-marilyn-monroe ""
   (logical (is-marilyn-monroe No))
   
   =>

   (assert (UI-state (display GoHomeAndChange) (state final))))

(defrule declare-marilyn-monroe ""
   (logical (is-marilyn-monroe Yes))
   
   =>

   (assert (UI-state (display LoveThatPicture) (state final))))

(defrule declare-walk-of-shame ""
   (logical (is-doing-walk-of-shame Yes))
   
   =>

   (assert (UI-state (display SomeoneHadFunNight) (state final))))
                     
(defrule unknown-if-dress ""

   (declare (salience -10))
  
   (logical (UI-state (id ?id)))
   (logical (query-item Dress))
   
   (state-list (current ?id))
     
   =>
  
   (assert (UI-state (display UnknownIfDress)
                     (state final))))
                     
(defrule unknown-if-pants ""

   (declare (salience -10))
  
   (logical (UI-state (id ?id)))
   (logical (query-item Pants))
   
   (state-list (current ?id))
     
   =>
  
   (assert (UI-state (display UnknownIfPants)
                     (state final))))
                     
;;;*************************
;;;* GUI INTERACTION RULES *
;;;*************************

(defrule ask-question

   (declare (salience 5))
   
   (UI-state (id ?id))
   
   ?f <- (state-list (sequence $?s&:(not (member$ ?id ?s))))
             
   =>
   
   (modify ?f (current ?id)
              (sequence ?id ?s))
   
   (halt))

(defrule handle-next-no-change-none-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
                      
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-response-none-end-of-chain

   (declare (salience 10))
   
   ?f <- (next ?id)

   (state-list (sequence ?id $?))
   
   (UI-state (id ?id)
             (relation-asserted ?relation))
                   
   =>
      
   (retract ?f)

   (assert (add-response ?id)))   

(defrule handle-next-no-change-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
     
   (UI-state (id ?id) (response ?response))
   
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-change-middle-of-chain

   (declare (salience 10))
   
   (next ?id ?response)

   ?f1 <- (state-list (current ?id) (sequence ?nid $?b ?id $?e))
     
   (UI-state (id ?id) (response ~?response))
   
   ?f2 <- (UI-state (id ?nid))
   
   =>
         
   (modify ?f1 (sequence ?b ?id ?e))
   
   (retract ?f2))
   
(defrule handle-next-response-end-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)
   
   (state-list (sequence ?id $?))
   
   ?f2 <- (UI-state (id ?id)
                    (response ?expected)
                    (relation-asserted ?relation))
                
   =>
      
   (retract ?f1)

   (if (neq ?response ?expected)
      then
      (modify ?f2 (response ?response)))
      
   (assert (add-response ?id ?response)))   

(defrule handle-add-response

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id ?response)
                
   =>
      
   (str-assert (str-cat "(" ?relation " " ?response ")"))
   
   (retract ?f1))   

(defrule handle-add-response-none

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id)
                
   =>
      
   (str-assert (str-cat "(" ?relation ")"))
   
   (retract ?f1))   

(defrule handle-prev

   (declare (salience 10))
      
   ?f1 <- (prev ?id)
   
   ?f2 <- (state-list (sequence $?b ?id ?p $?e))
                
   =>
   
   (retract ?f1)
   
   (modify ?f2 (current ?p))
   
   (halt))
   
