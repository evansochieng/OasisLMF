#!/usr/bin/env -S bash -euET -o pipefail -O inherit_errexit
SCRIPT=$(readlink -f "$0") && cd $(dirname "$SCRIPT")

# --- Script Init ---

mkdir -p log
rm -R -f log/*


touch log/stderror.err
ktools_monitor.sh $$ & pid0=$!

exit_handler(){
   exit_code=$?
   kill -9 $pid0 2> /dev/null
   if [ "$exit_code" -gt 0 ]; then
       echo 'Ktools Run Error - exitcode='$exit_code
   else
       echo 'Run Completed'
   fi

   set +x
   group_pid=$(ps -p $$ -o pgid --no-headers)
   sess_pid=$(ps -p $$ -o sess --no-headers)
   script_pid=$$
   printf "Script PID:%d, GPID:%s, SPID:%d
" $script_pid $group_pid $sess_pid >> log/killout.txt

   ps -jf f -g $sess_pid > log/subprocess_list
   PIDS_KILL=$(pgrep -a --pgroup $group_pid | awk 'BEGIN { FS = "[ \t\n]+" }{ if ($1 >= '$script_pid') print}' | grep -v celery | egrep -v *\\.log$  | egrep -v *\\.sh$ | sort -n -r)
   echo "$PIDS_KILL" >> log/killout.txt
   kill -9 $(echo "$PIDS_KILL" | awk 'BEGIN { FS = "[ \t\n]+" }{ print $1 }') 2>/dev/null
   exit $exit_code
}
trap exit_handler QUIT HUP INT KILL TERM ERR EXIT

check_complete(){
    set +e
    proc_list="eve getmodel gulcalc fmcalc summarycalc eltcalc aalcalc leccalc pltcalc ordleccalc"
    has_error=0
    for p in $proc_list; do
        started=$(find log -name "$p*.log" | wc -l)
        finished=$(find log -name "$p*.log" -exec grep -l "finish" {} + | wc -l)
        if [ "$finished" -lt "$started" ]; then
            echo "[ERROR] $p - $((started-finished)) processes lost"
            has_error=1
        elif [ "$started" -gt 0 ]; then
            echo "[OK] $p"
        fi
    done
    if [ "$has_error" -ne 0 ]; then
        false # raise non-zero exit code
    fi
}
# --- Setup run dirs ---

find output -type f -not -name '*summary-info*' -not -name '*.json' -exec rm -R -f {} +

rm -R -f fifo/*
rm -R -f work/*
mkdir work/kat/

mkdir work/gul_S1_summary_palt
mkdir work/gul_S2_summary_palt

mkfifo fifo/gul_P1
mkfifo fifo/gul_P2
mkfifo fifo/gul_P3
mkfifo fifo/gul_P4
mkfifo fifo/gul_P5
mkfifo fifo/gul_P6
mkfifo fifo/gul_P7
mkfifo fifo/gul_P8
mkfifo fifo/gul_P9
mkfifo fifo/gul_P10

mkfifo fifo/gul_S1_summary_P1
mkfifo fifo/gul_S2_summary_P1

mkfifo fifo/gul_S1_summary_P2
mkfifo fifo/gul_S2_summary_P2

mkfifo fifo/gul_S1_summary_P3
mkfifo fifo/gul_S2_summary_P3

mkfifo fifo/gul_S1_summary_P4
mkfifo fifo/gul_S2_summary_P4

mkfifo fifo/gul_S1_summary_P5
mkfifo fifo/gul_S2_summary_P5

mkfifo fifo/gul_S1_summary_P6
mkfifo fifo/gul_S2_summary_P6

mkfifo fifo/gul_S1_summary_P7
mkfifo fifo/gul_S2_summary_P7

mkfifo fifo/gul_S1_summary_P8
mkfifo fifo/gul_S2_summary_P8

mkfifo fifo/gul_S1_summary_P9
mkfifo fifo/gul_S2_summary_P9

mkfifo fifo/gul_S1_summary_P10
mkfifo fifo/gul_S2_summary_P10



# --- Do ground up loss computes ---


tee < fifo/gul_S1_summary_P1 work/gul_S1_summary_palt/P1.bin > /dev/null & pid1=$!
tee < fifo/gul_S2_summary_P1 work/gul_S2_summary_palt/P1.bin > /dev/null & pid2=$!
tee < fifo/gul_S1_summary_P2 work/gul_S1_summary_palt/P2.bin > /dev/null & pid3=$!
tee < fifo/gul_S2_summary_P2 work/gul_S2_summary_palt/P2.bin > /dev/null & pid4=$!
tee < fifo/gul_S1_summary_P3 work/gul_S1_summary_palt/P3.bin > /dev/null & pid5=$!
tee < fifo/gul_S2_summary_P3 work/gul_S2_summary_palt/P3.bin > /dev/null & pid6=$!
tee < fifo/gul_S1_summary_P4 work/gul_S1_summary_palt/P4.bin > /dev/null & pid7=$!
tee < fifo/gul_S2_summary_P4 work/gul_S2_summary_palt/P4.bin > /dev/null & pid8=$!
tee < fifo/gul_S1_summary_P5 work/gul_S1_summary_palt/P5.bin > /dev/null & pid9=$!
tee < fifo/gul_S2_summary_P5 work/gul_S2_summary_palt/P5.bin > /dev/null & pid10=$!
tee < fifo/gul_S1_summary_P6 work/gul_S1_summary_palt/P6.bin > /dev/null & pid11=$!
tee < fifo/gul_S2_summary_P6 work/gul_S2_summary_palt/P6.bin > /dev/null & pid12=$!
tee < fifo/gul_S1_summary_P7 work/gul_S1_summary_palt/P7.bin > /dev/null & pid13=$!
tee < fifo/gul_S2_summary_P7 work/gul_S2_summary_palt/P7.bin > /dev/null & pid14=$!
tee < fifo/gul_S1_summary_P8 work/gul_S1_summary_palt/P8.bin > /dev/null & pid15=$!
tee < fifo/gul_S2_summary_P8 work/gul_S2_summary_palt/P8.bin > /dev/null & pid16=$!
tee < fifo/gul_S1_summary_P9 work/gul_S1_summary_palt/P9.bin > /dev/null & pid17=$!
tee < fifo/gul_S2_summary_P9 work/gul_S2_summary_palt/P9.bin > /dev/null & pid18=$!
tee < fifo/gul_S1_summary_P10 work/gul_S1_summary_palt/P10.bin > /dev/null & pid19=$!
tee < fifo/gul_S2_summary_P10 work/gul_S2_summary_palt/P10.bin > /dev/null & pid20=$!

( summarycalc -m -i  -1 fifo/gul_S1_summary_P1 -2 fifo/gul_S2_summary_P1 < fifo/gul_P1 ) 2>> log/stderror.err  &
( summarycalc -m -i  -1 fifo/gul_S1_summary_P2 -2 fifo/gul_S2_summary_P2 < fifo/gul_P2 ) 2>> log/stderror.err  &
( summarycalc -m -i  -1 fifo/gul_S1_summary_P3 -2 fifo/gul_S2_summary_P3 < fifo/gul_P3 ) 2>> log/stderror.err  &
( summarycalc -m -i  -1 fifo/gul_S1_summary_P4 -2 fifo/gul_S2_summary_P4 < fifo/gul_P4 ) 2>> log/stderror.err  &
( summarycalc -m -i  -1 fifo/gul_S1_summary_P5 -2 fifo/gul_S2_summary_P5 < fifo/gul_P5 ) 2>> log/stderror.err  &
( summarycalc -m -i  -1 fifo/gul_S1_summary_P6 -2 fifo/gul_S2_summary_P6 < fifo/gul_P6 ) 2>> log/stderror.err  &
( summarycalc -m -i  -1 fifo/gul_S1_summary_P7 -2 fifo/gul_S2_summary_P7 < fifo/gul_P7 ) 2>> log/stderror.err  &
( summarycalc -m -i  -1 fifo/gul_S1_summary_P8 -2 fifo/gul_S2_summary_P8 < fifo/gul_P8 ) 2>> log/stderror.err  &
( summarycalc -m -i  -1 fifo/gul_S1_summary_P9 -2 fifo/gul_S2_summary_P9 < fifo/gul_P9 ) 2>> log/stderror.err  &
( summarycalc -m -i  -1 fifo/gul_S1_summary_P10 -2 fifo/gul_S2_summary_P10 < fifo/gul_P10 ) 2>> log/stderror.err  &

( eve 1 10 | getmodel | gulcalc -S0 -L0 -r -a1 -i - > fifo/gul_P1  ) 2>> log/stderror.err &
( eve 2 10 | getmodel | gulcalc -S0 -L0 -r -a1 -i - > fifo/gul_P2  ) 2>> log/stderror.err &
( eve 3 10 | getmodel | gulcalc -S0 -L0 -r -a1 -i - > fifo/gul_P3  ) 2>> log/stderror.err &
( eve 4 10 | getmodel | gulcalc -S0 -L0 -r -a1 -i - > fifo/gul_P4  ) 2>> log/stderror.err &
( eve 5 10 | getmodel | gulcalc -S0 -L0 -r -a1 -i - > fifo/gul_P5  ) 2>> log/stderror.err &
( eve 6 10 | getmodel | gulcalc -S0 -L0 -r -a1 -i - > fifo/gul_P6  ) 2>> log/stderror.err &
( eve 7 10 | getmodel | gulcalc -S0 -L0 -r -a1 -i - > fifo/gul_P7  ) 2>> log/stderror.err &
( eve 8 10 | getmodel | gulcalc -S0 -L0 -r -a1 -i - > fifo/gul_P8  ) 2>> log/stderror.err &
( eve 9 10 | getmodel | gulcalc -S0 -L0 -r -a1 -i - > fifo/gul_P9  ) 2>> log/stderror.err &
( eve 10 10 | getmodel | gulcalc -S0 -L0 -r -a1 -i - > fifo/gul_P10  ) 2>> log/stderror.err &

wait $pid1 $pid2 $pid3 $pid4 $pid5 $pid6 $pid7 $pid8 $pid9 $pid10 $pid11 $pid12 $pid13 $pid14 $pid15 $pid16 $pid17 $pid18 $pid19 $pid20


# --- Do ground up loss kats ---


( aalcalc -Kgul_S1_summary_palt -o > output/gul_S1_palt.csv ) 2>> log/stderror.err & lpid1=$!
( aalcalc -Kgul_S2_summary_palt -o > output/gul_S2_palt.csv ) 2>> log/stderror.err & lpid2=$!
wait $lpid1 $lpid2

rm -R -f work/*
rm -R -f fifo/*

check_complete
exit_handler