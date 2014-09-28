(require psilocybin.language)


(let [[lucifer-v4 "97.107.130.79"]
      [lucifer-v6 "2600:3c03::f03c:91ff:fe93:8e40"]]

  (zone "lucifer"
    ["@" :IN :A     lucifer-v4]
    ["*" :IN :A     lucifer-v4]
    ["@" :IN :AAAA  lucifer-v6]
    ["*" :IN :AAAA  lucifer-v6]))
