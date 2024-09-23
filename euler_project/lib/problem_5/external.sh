gcd() {
  local a=$1
  local b=$2
  while [ $b -ne 0 ]; do
    local temp=$b
    b=$((a % b))
    a=$temp
  done
  echo $a
}

lcm() {
  local a=$1
  local b=$2
  echo $((a * b / $(gcd $a $b)))
}

result=1

for i in {1..20}; do
  result=$(lcm $result $i)
done

echo $result
