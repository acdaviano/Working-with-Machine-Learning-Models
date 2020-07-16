#install tictactoe package to train a tictactoe AI
install.packages("tictactoe")
library(tictactoe)
#I then used the ttt_ai to simulate tictactoe games with a strong AI (level 5)
ttt(ttt_ai(level = 5), ttt_ai(level = 5))
#after a couple of games we see that we can train one of the AIs to be 
#stronger than the limit of 5
#we then do a large scale similation of the AIs against each other to train a strong AI player
#we will do a large number of games to train the AIs and then see the results in a table
#we do a game between to untrained AIs below, then we look at the 0 = draw, then 1 = games 
#won by AI 1, 2 = game won by AI 2
res <- ttt_simulate(ttt_ai(), ttt_ai(), N = 100, verbose = FALSE)
prop.table(table(res))#first we simulate low that then raise the numebr of games
res <- ttt_simulate(ttt_ai(), ttt_ai(), N = 250, verbose = FALSE)
prop.table(table(res))#we see with this increase in simulations we have better results
#we will then train one of the AIs and see that it gets strionger than the random AI to 
#gain better rewards/results from games
p <- ttt_ai()
o <- ttt_qlearn(p, N = 500, verbose = FALSE)
res <- ttt_simulate(ttt_ai(), p, N = 100, verbose = FALSE)
prop.table(table(res))#this allows us to visualize that the AI we trained get a lot stronger
#we can also add another 500 to the AI to see if it gets even stronger
p2 <- ttt_ai()
o2 <- ttt_qlearn(p2, N = 1000, verbose = FALSE)
res2 <- ttt_simulate(ttt_ai(), p2, N = 100, verbose = FALSE)
prop.table(table(res2))#here we can see that we get another gain in strength of our AI by 
#adding 500 more simulations to the training