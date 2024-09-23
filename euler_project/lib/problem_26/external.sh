cycle_length() {
  local d=$1
  local num=1
  local count=0
  declare -A seen

  while [ $num -ne 0 ]; do
    num=$((num % d))
    if [ ${seen[$num]+_} ]; then
      echo $((count - seen[$num]))
      return
    fi
    seen[$num]=$count
    num=$((num * 10))
    count=$((count + 1))
  done

  echo 0
}

max_length=0
result=0

for d in {1..999}; do
  length=$(cycle_length $d)
  if [ $length -gt $max_length ]; then
    max_length=$length
    result=$d
  fi
done

echo $result
