setwd("..")
sndshare::dir_to_csv("sndshare", "sndshare.csv")
setwd("sndshare")
fs::file_move("../sndshare.csv", "~/sasdata1/download/")
