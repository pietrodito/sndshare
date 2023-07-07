setwd("..")
sndshare::dir_to_txt("sndshare", "sndshare.txt")
setwd("sndshare")
fs::file_move("../sndshare.txt", "~/sasdata1/download/")
