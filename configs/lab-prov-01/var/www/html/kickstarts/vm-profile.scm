((server
  (title . "Setup for server")
  (action . trivial)
  (actiondata ("swap" (size 2097152 . 2097152) (fsim . "SWAPFS") (methods plain))
              ("/" (size 8388608 . #t) (fsim . "Ext4") (methods plain))))
)
