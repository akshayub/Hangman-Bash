clear
readarray a < list
function wrong1 {
echo "        O           "
}
function wrong2 {
printf "         O          "
printf "\n"
echo -n "         |           "
}
function wrong3 {
printf "         O          "
printf "\n"
echo -n "         |\           "
}
function wrong4 {
printf "         O          "
printf "\n"
echo -n "        /|\           "
}
function wrong5 {
printf "         O          "
printf "\n"
echo -n "        /|\           "
printf "\n"
echo -n "         /            "
}
function wrong6 {
printf "         O          "
printf "\n"
echo -n "        /|\           "
printf "\n"
echo -n "         /\            "
}
function wrong7 {
printf "        |          "
printf "         O          "
printf "\n"
echo -n "        /|\           "
printf "\n"
echo -n "         /\            "
}

function display {
DATA[0]=" #     #    #    #     #  #####  #     #    #    #     #"
DATA[1]=" #     #   # #   ##    # #     # ##   ##   # #   ##    #"
DATA[2]=" #     #  #   #  # #   # #       # # # #  #   #  # #   #"
DATA[3]=" ####### #     # #  #  # #  #### #  #  # #     # #  #  #"
DATA[4]=" #     # ####### #   # # #     # #     # ####### #   # #"
DATA[5]=" #     # #     # #    ## #     # #     # #     # #    ##"
DATA[6]=" #     # #     # #     #  #####  #     # #     # #     #"
echo


# virtual coordinate system is X*Y ${#DATA} * 8

REAL_OFFSET_X=0
REAL_OFFSET_Y=0

draw_char() {
  V_COORD_X=$1
  V_COORD_Y=$2

  tput cup $((REAL_OFFSET_Y + V_COORD_Y)) $((REAL_OFFSET_X + V_COORD_X))

  printf %c ${DATA[V_COORD_Y]:V_COORD_X:1}
}

trap 'exit 1' INT TERM
trap 'tput setaf 9; tput cvvis; clear' EXIT

tput civis
clear
tempp=8
while :; do
tempp=`expr $tempp - 8`
for ((c=1; c <= 7; c++)); do
  tput setaf $c
  for ((x=0; x<${#DATA[0]}; x++)); do
    for ((y=0; y<=6; y++)); do
      draw_char $x $y
    done
  done
done
sleep 1
clear
break
done
}

echo

display

randind=`expr $RANDOM % ${#a[@]}`

movie=${a[$randind]}
# echo $movie

guess=()

guesslist=()
guin=0

movie=`echo $movie | tr -dc '[:alnum:] \n\r' | tr '[:upper:]' '[:lower:]'`
len=${#movie}

for ((i=0;i<$len;i++)); do
    guess[$i]="_"
done

mov=()

for ((i=0;i<$len;i++)); do
    mov[$i]=${movie:$i:1}
    # echo -n "${mov[$i]} "
done

for ((j=0;j<$len;j++)); do
    if [[ ${mov[$j]} == " " ]]; then
        guess[$j]=" "
    fi
done

## Display the initial setup

wrong=0

while [[ $wrong -lt 7 ]]; do
    case $wrong in
    0)echo " "
    ;;
    1)wrong1
    ;;
    2)wrong2
    ;;
    3)wrong3
    ;;
    4)wrong4
    ;;
    5)wrong5
    ;;
    6)wrong6
    ;;
    7)wrong7
    ;;
esac
    echo Guess List: ${guesslist[@]}
    echo Wrong guesses: $wrong
    for ((k=0;k<$len;k++)); do
        echo -n "${guess[$k]} "
    done
    echo
    echo
    echo -n "Guess a letter: "
    read -n 1 -e letter
    guesslist[$guin]=$letter
    guin=`expr $guin + 1`

    f=0;
    for ((i=0;i<$len;i++)); do
        if [[ ${mov[$i]} == $letter ]]; then
            guess[$i]=$letter
            f=1
        fi
    done
    if [[ f -eq 0 ]]; then
        wrong=`expr $wrong + 1`
    fi
    ##Hangman goes here

    ##Hangman should end here
    notover=0
    for ((j=0;j<$len;j++)); do
        if [[ ${guess[$j]} == "_" ]]; then
            notover=1
        fi
    done
    if [[ notover -eq 0 ]]; then
        echo You Win!
        for ((k=0;k<$len;k++)); do
            echo -n "${guess[$k]} "
        done
        echo
        exit
    fi
    clear
done
printf "         |          "
printf "\n"
printf "         O          "
printf "\n"
echo -n "        /|\           "
printf "\n"
echo -n "        / \            "
echo You lost!
echo The movie was: $movie                                            

