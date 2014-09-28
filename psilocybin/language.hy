(import [os.path [expanduser]]
        [psilocybin.gandi [GandiProxy]])


(with [[fd (open (expanduser "~/.psilocybin.key") "r")]]
  (def apikey (-> fd .read .strip)))


(defn get-zone-records [zone-id]
  (let [[proxy (GandiProxy apikey)]
        [record (.get-zone-records proxy zone-id)]]
    (psilocybin-stream-to-dict record)))


(defn parse-psilocybin-record-a [entry]
  (let [[(, name _ _ value) entry]]
    {"name" name
     "value" value
     "type" "A"}))


(defn parse-psilocybin-record-aaaa [entry]
  (let [[(, name _ _ value) entry]]
    {"name" name
     "value" value
     "type" "AAAA"}))


(defn parse-psilocybin-record [entry]
  (let [[handlers {:A parse-psilocybin-record-a
                   :AAAA parse-psilocybin-record-aaaa}]
        [handler (get handlers (get entry 2))]]
    (handler entry)))


(defn psilocybin-record-slug [entry]
  (.format "{}-{}" (get entry "type") (get entry "name")))


(defn psilocybin-stream-to-dict [stream]
  (dict-comp
    (psilocybin-record-slug x) x
    [x stream]))


(defn parse-psilocybin-records [entries]
  (psilocybin-stream-to-dict
    (genexpr (parse-psilocybin-record x) [x entries])))


(defmacro/g! zone [zone-id &rest records]
  `(do
    (import [psilocybin.language [get-zone-records parse-psilocybin-records]])
    (print (parse-psilocybin-records [~@records]))
))
    ; (print (get-zone-records ~zone-id))))
