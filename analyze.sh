#!/bin/bash
#Jaden DeVinney & Zachary Humes

read -p "Enter a file path: " file_path
read -p "Enter first column: " column1
read -p "Enter second column: " column2

column1_data=()
column2_data=()

# File into an array
IFS="$IFS,"
while IFS= read -r line; do
count=0
    for item in ${line[@]}; do
        ((count++))
        if (( $count == $column1 )); then
            column1_data+=( $item )
        fi
        if (( $count == $column2 )); then
            column2_data+=( $item )
        fi
    done
done < ${file_path}

unset "column1_data[0]"
unset "column2_data[0]"

# Sort the array
sorted_data_1=($(printf "%s\n" "${column1_data[@]}" | sort -g ))
sorted_data_2=($(printf "%s\n" "${column2_data[@]}" | sort -g ))
# Variables for readability
n_1=${#column2_data[@]}
n_2=${#column2_data[@]}
q1_index_1=$((n_1 / 4)) 
q1_index_2=$((n_2 / 4))
q3_index_1=$((q1_index_1 * 3))
q3_index_2=$((q1_index_2 * 3))
q2_index_1=$((n_1 / 2))
q2_index_2=$((n_2 / 2))

# Find Q1, Q2, and Q3 of column 1
if ((n_1 % 2 == 0)); then
    # Array length is even
    
    if (( (( n_1 / 2 )) % 2 == 0)); then
        # Lower half is even

        q1_1=$(echo "scale=16; (${sorted_data_1[q1_index_1 - 1]}) + (${sorted_data_1[q1_index_1]})" | bc)
        q1_1=$(echo "scale=16; $q1_1 / 2" | bc)
        q3_1=$(echo "scale=16; (${sorted_data_1[q3_index_1 - 1]}) + (${sorted_data_1[q3_index_1]})" | bc)
        q3_1=$(echo "scale=16; $q3_1 / 2" | bc)
    else
        # Lower half is odd
    	
        q1_1=${sorted_data_1[q1_index_1]}
        q3_1=${sorted_data_1[q3_index_1]}
    fi
    
    q2_1=$(echo "scale=16; (${sorted_data_1[q2_index_1 - 1]}) + (${sorted_data_1[q2_index_1]})" | bc)
    q2_1=$(echo "scale=16; $q2_1 / 2" | bc)
else
    # Array length is odd

    if (( (( n_1 / 2 )) % 2 == 0 )); then
        # Lower half is even
        q1_1=$(echo "scale=16; (${sorted_data_1[q1_index_1 - 1]}) + (${sorted_data_1[q1_index_1]})" | bc)
        q1_1=$(echo "scale=16; $q1_1 / 2" | bc)
        q3_1=$(echo "scale=16; (${sorted_data_1[q3_index_1 + 1]}) + (${sorted_data_1[q3_index_1]})" | bc)
        q3_1=$(echo "scale=16; $q3_1 / 2" | bc)
    else
        # Lower half is odd

        q1_1=${sorted_data_1[q1_index_1]}
        q3_1=${sorted_data_1[q3_index_1]}
    fi

    q2_1=${sorted_data_1[q2_index_1]}
fi

# Find Q1, Q2, and Q3 of column 2
if ((n_2 % 2 == 0)); then
    # Array length is even
    
    if (( (( n_2 / 2 )) % 2 == 0)); then
        # Lower half is even
        
        q1_2=$(echo "scale=16; (${sorted_data_2[q1_index_2 - 1]}) + (${sorted_data_2[q1_index_2]})" | bc)
        q1_2=$(echo "scale=16; $q1_2 / 2" | bc)
        q3_2=$(echo "scale=16; (${sorted_data_2[q3_index_2 - 1]}) + (${sorted_data_2[q3_index_2]})" | bc)
        q3_2=$(echo "scale=16; $q3_2 / 2" | bc)
    else
        # Lower half is odd
    	
        q1_2=${sorted_data_2[q1_index_2]}
        q3_2=${sorted_data_2[q3_index_2]}
    fi
    
    q2_2=$(echo "scale=16; (${sorted_data_2[q2_index_2 - 1]}) + (${sorted_data_2[q2_index_2]})" | bc)
    q2_2=$(echo "scale=16; $q2_2 / 2" | bc)
else
    # Array length is odd
    
    if (( (( n_2 / 2 )) % 2 == 0 )); then
        # Lower half is even
        
        q1_2=$(echo "scale=16; ${sorted_data_2[q1_index_2 - 1]} + ${sorted_data_2[q1_index_2]}" | bc)
        q1_2=$(echo "scale=16; $q1_2 / 2" | bc)
        q3_2=$(echo "scale=16; ${sorted_data_2[q3_index_2 + 1]} + ${sorted_data_2[q3_index_2]}" | bc)
        q3_2=$(echo "scale=16; $q3_2 / 2" | bc)
    else
        # Lower half is odd
        q1_2=${sorted_data_2[q1_index_2]}
        q3_2=${sorted_data_2[q3_index_2]}
    fi
    
    q2_2=${sorted_data_2[q2_index_2]}
fi

# Data_1 Average
sum=0
for item in ${sorted_data_1[@]}; do
    sum=$(echo "scale=16; $sum + $item" | bc )
done

average_1=$(echo "scale=16; $sum / $n_1" | bc )
average_display_1=$(printf "%.4f" $average_1)

# Data_2 average
sum=0
for item in ${sorted_data_2[@]}; do
    sum=$(echo "scale=16; $sum + $item" | bc )
done

average_2=$(echo "scale=16; $sum / $n_2" | bc )
average_display_2=$(printf "%.4f" $average_2)

# Calculate Standard deviation_1
sum=0
for item in "${sorted_data_1[@]}"; do
    diff=$(echo "scale=16; $item - $average_1" | bc )
    sum=$(echo "scale=16; $sum + ($diff * $diff)" | bc )
done

stdev_1=$(echo "scale=16; $sum / $n_1" | bc)
stdev_1=$(echo "scale=16; sqrt($stdev_1)" | bc )

stdev_display_1=$(printf "%.4f" $stdev_1)


# Calculate Standard deviation_2
sum=0
for item in "${sorted_data_2[@]}"; do
    diff=$(echo "scale=16; $item - $average_2" | bc )
    sum=$(echo "scale=16; $sum + ($diff * $diff)" | bc )
done

stdev_2=$(echo "scale=16; $sum / $n_2" | bc)
stdev_2=$(echo "scale=16; sqrt($stdev_2)" | bc )

stdev_display_2=$(printf "%.4f" $stdev_2)

# Confidence interval_1

sqrt_n_1=$(echo "scale=16; sqrt($n_1)" | bc)
sem_1=$(echo "scale=16; $stdev_1 / $sqrt_n_1" | bc )

margin_of_error_90_1=$(echo "scale=16; $sem_1 * 1.645" | bc )
margin_of_error_95_1=$(echo "scale=16; $sem_1 * 1.96" | bc )
margin_of_error_99_1=$(echo "scale=16; $sem_1 * 2.576" | bc )
margin_of_error_999_1=$(echo "scale=16; $sem_1 * 3.291" | bc )
margin_of_error_display_90_1=$(printf "%.4f" $margin_of_error_90_1)
margin_of_error_display_95_1=$(printf "%.4f" $margin_of_error_95_1)
margin_of_error_display_99_1=$(printf "%.4f" $margin_of_error_99_1)
margin_of_error_display_999_1=$(printf "%.4f" $margin_of_error_999_1)

lower_value_90_1=$(echo "scale=16; $average_1 - $margin_of_error_90_1" | bc ); lower_value_90_1=$(printf "%.4f" $lower_value_90_1)
upper_value_90_1=$(echo "scale=16; $average_1 + $margin_of_error_90_1" | bc ); upper_value_90_1=$(printf "%.4f" $upper_value_90_1)
lower_value_95_1=$(echo "scale=16; $average_1 - $margin_of_error_95_1" | bc ); lower_value_95_1=$(printf "%.4f" $lower_value_95_1)
upper_value_95_1=$(echo "scale=16; $average_1 + $margin_of_error_95_1" | bc ); upper_value_95_1=$(printf "%.4f" $upper_value_95_1)
lower_value_99_1=$(echo "scale=16; $average_1 - $margin_of_error_99_1" | bc ); lower_value_99_1=$(printf "%.4f" $lower_value_99_1)
upper_value_99_1=$(echo "scale=16; $average_1 + $margin_of_error_999_1" | bc ); upper_value_99_1=$(printf "%.4f" $upper_value_99_1)
lower_value_999_1=$(echo "scale=16; $average_1 - $margin_of_error_999_1" | bc ); lower_value_999_1=$(printf "%.4f" $lower_value_999_1)
upper_value_999_1=$(echo "scale=16; $average_1 + $margin_of_error_999_1" | bc ); upper_value_999_1=$(printf "%.4f" $upper_value_999_1)

interval_90_1=( $lower_value_90_1 $upper_value_90_1 )
interval_95_1=( $lower_value_95_1 $upper_value_95_1 )
interval_99_1=( $lower_value_99_1 $upper_value_99_1 )
interval_999_1=( $lower_value_999_1 $upper_value_999_1 )

# Confidence interval_2
sqrt_n_2=$(echo "scale=16; sqrt($n_2)" | bc)
sem_2=$(echo "scale=16; $stdev_2 / $sqrt_n_2" | bc )

margin_of_error_90_2=$(echo "scale=16; $sem_2 * 1.645" | bc )
margin_of_error_95_2=$(echo "scale=16; $sem_2 * 1.96" | bc )
margin_of_error_99_2=$(echo "scale=16; $sem_2 * 2.576" | bc )
margin_of_error_999_2=$(echo "scale=16; $sem_2 * 3.291" | bc )
margin_of_error_display_90_2=$(printf "%.4f" $margin_of_error_90_2)
margin_of_error_display_95_2=$(printf "%.4f" $margin_of_error_95_2)
margin_of_error_display_99_2=$(printf "%.4f" $margin_of_error_99_2)
margin_of_error_display_999_2=$(printf "%.4f" $margin_of_error_999_2)

lower_value_90_2=$(echo "scale=16; $average_2 - $margin_of_error_90_2" | bc ); lower_value_90_2=$(printf "%.4f" $lower_value_90_2)
upper_value_90_2=$(echo "scale=16; $average_2 + $margin_of_error_90_2" | bc ); upper_value_90_2=$(printf "%.4f" $upper_value_90_2)
lower_value_95_2=$(echo "scale=16; $average_2 - $margin_of_error_95_2" | bc ); lower_value_95_2=$(printf "%.4f" $lower_value_95_2)
upper_value_95_2=$(echo "scale=16; $average_2 + $margin_of_error_95_2" | bc ); upper_value_95_2=$(printf "%.4f" $upper_value_95_2)
lower_value_99_2=$(echo "scale=16; $average_2 - $margin_of_error_99_2" | bc ); lower_value_99_2=$(printf "%.4f" $lower_value_99_2)
upper_value_99_2=$(echo "scale=16; $average_2 + $margin_of_error_999_2" | bc ); upper_value_99_2=$(printf "%.4f" $upper_value_99_2)
lower_value_999_2=$(echo "scale=16; $average_2 - $margin_of_error_999_2" | bc ); lower_value_999_2=$(printf "%.4f" $lower_value_999_2)
upper_value_999_2=$(echo "scale=16; $average_2 + $margin_of_error_999_2" | bc ); upper_value_999_2=$(printf "%.4f" $upper_value_999_2)

interval_90_2=( $lower_value_90_2 $upper_value_90_2 )
interval_95_2=( $lower_value_95_2 $upper_value_95_2 )
interval_99_2=( $lower_value_99_2 $upper_value_99_2 )
interval_999_2=( $lower_value_999_2 $upper_value_999_2 )

# Finding the upper and lower extremes
iqr_1=$(echo "scale=16; $q3_1 - $q1_1" | bc )
lower_extreme_1=$(echo "scale=16; $q1_1 - (1.5 * $iqr_1)" | bc )
upper_extreme_1=$(echo "scale=16; $q3_1 + (1.5 * $iqr_1)" | bc )

iqr_2=$(echo "scale=16; $q3_2 - $q1_2" | bc )
lower_extreme_2=$(echo "scale=16; $q1_2 - (1.5 * $iqr_2)" | bc )
upper_extreme_2=$(echo "scale=16; $q3_2 + (1.5 * $iqr_2)" | bc )

outliers_1=()
for item in ${sorted_data_1[@]}; do
    if (( $(echo "$item < $lower_extreme_1" | bc -l) == 1 )) || (( $(echo "$item > $upper_extreme_1" | bc -l) == 1 )); then
        outliers_1+=( $item )
    fi
done
for item in ${sorted_data_2[@]}; do
    if (( $(echo "$item < $lower_extreme_2" | bc -l) == 1 )) || (( $(echo "$item > $upper_extreme_2" | bc -l) == 1 )); then
        outliers_2+=( $item )
    fi
done

# Data normalization
min_1=${sorted_data_1[0]}
min_2=${sorted_data_2[0]}
max_1=${sorted_data_1[${#sorted_data_1[@]} - 1]}
max_2=${sorted_data_2[${#sorted_data_2[@]} - 1]}

normal_data_1=()
for item in ${sorted_data_1[@]}; do
    normalized=$(echo "scale=16; ($item - $min_1) / ($max_1 - $min_1)" | bc ); normalized=$(printf "%.4f" "$normalized")
    normal_data_1+=( $normalized )
done
normal_data_2=()
for item in ${sorted_data_2[@]}; do
    normalized=$(echo "scale=16; ($item - $min_2) / ($max_2 - $min_2)" | bc ); normalized=$(printf "%.4f" "$normalized")
    normal_data_2+=( $normalized )
done

echo "--== Data set 1 normalized values ==--" > normalized_array_1.txt
for item in ${normal_data_1[@]}; do
    echo "$item" >> normalized_array_1.txt
done
echo "--== Data set 2 normalized values ==--" > normalized_array_2.txt
for item in ${normal_data_2[@]}; do
    echo "$item" >> normalized_array_2.txt
done

# Determine size of brackets_1
result=$(echo "${sorted_data_1[$n_1-1]} % 10 == 0" | bc -l )
if (( $result == 1 )); then
    bracket_size_1=$(echo "scale=16; ${sorted_data_1[$n_1-1]} / 10" | bc )
else
    bracket_size_1=$(echo "scale=16; ${sorted_data_1[$n_1-1]} / 10 + 1" | bc )
fi

# Determine size of brackets_2
result=$(echo "${sorted_data_2[$n_2-1]} % 10 == 0" | bc -l )
if (( $result == 1 )); then
    bracket_size_2=$(echo "scale=16; ${sorted_data_2[$n_2-1]} / 10" | bc )
else
    bracket_size_2=$(echo "scale=16; ${sorted_data_2[$n_2-1]} / 10 + 1" | bc )
fi

bar_graph_1=()
bar_graph_2=()

# Fill barbraph brackets_1
for ((i = 0; i < 10; i++)); do
    bar=""
    count=0
    for item in ${sorted_data_1[@]}; do
    result=$(echo "$item >= $i * $bracket_size_1" | bc -l)
    result2=$(echo "$item <= ($i + 1) * $bracket_size_1" | bc -l)
        if (( result == 1 )) && (( result2 == 1 )); then
            bar+="▌"
            count=$(($count + 1))
        fi
    done
    bar+="($count)"
    bar_graph_1+=( $bar )
done

# Fill barbraph brackets_2
for ((i = 0; i < 10; i++)); do
    bar=""
    count=0
    for item in ${sorted_data_2[@]}; do
    result=$(echo "$item >= $i * $bracket_size_2" | bc -l)
    result2=$(echo "$item <= ($i + 1) * $bracket_size_2" | bc -l)
        if (( result == 1 )) && (( result2 == 1 )); then
            bar+="▌"
            count=$(($count + 1))
        fi
    done
    bar+="($count)"
    bar_graph_2+=( $bar )
done

# Display bargraph_1
echo
echo "--== Data set 1 histogram ==--"
for index in ${!bar_graph_1[@]}; do
    upper_index=$((index + 1))
    lower_bracket=$(echo "scale=4; ($index * $bracket_size_1)" | bc); lower_bracket=$(printf "%.4f" "$lower_bracket")
    upper_bracket=$(echo "scale=4; ($upper_index * $bracket_size_1)" | bc); upper_bracket=$(printf "%.4f" "$upper_bracket")
    echo "$lower_bracket - $upper_bracket : ${bar_graph_1[index]}"
done

# Display bargraph_2
echo
echo "--== Data set 2 histogram ==--"
for index in ${!bar_graph_2[@]}; do
    upper_index=$((index + 1))
    lower_bracket=$(echo "scale=4; ($index * $bracket_size_2)" | bc); lower_bracket=$(printf "%.4f" "$lower_bracket")
    upper_bracket=$(echo "scale=4; ($upper_index * $bracket_size_2)" | bc); upper_bracket=$(printf "%.4f" "$upper_bracket")
    echo "$lower_bracket - $upper_bracket : ${bar_graph_2[index]}"
done

# Round Q1, Q2, Q3
q1_1=$(printf "%.4f" $q1_1)
q2_1=$(printf "%.4f" $q2_1)
q3_1=$(printf "%.4f" $q3_1)
q1_2=$(printf "%.4f" $q1_2)
q2_2=$(printf "%.4f" $q2_2)
q3_2=$(printf "%.4f" $q3_2)

# Output outliers
if [ ${#outliers_1[@]} -eq 0 ]; then
    outliers_1+=( "None" )
fi
if (( ${#outliers_2[@]} == 0 )); then
    outliers_2+=( "None" )
fi


# Output variables
echo
echo "--== Data set 1 ==--"
echo "Quartile 1: $q1_1"
echo "Quartile 2: $q2_1"
echo "Quartile 3: $q3_1"
echo "Lower extreme: $lower_extreme_1" 
echo "Upper extreme: $upper_extreme_1"
echo "Average: $average_display_1"
echo "Standard Deviation: $stdev_display_1"
echo "90% confidence interval: ${interval_90_1[0]} - ${interval_90_1[1]}"
echo "95% confidence interval: ${interval_95_1[0]} - ${interval_95_1[1]}"
echo "99% confidence interval: ${interval_99_1[0]} - ${interval_99_1[1]}"
echo "99.9% confidence interval: ${interval_999_1[0]} - ${interval_999_1[1]}"
echo "Outliers: ${outliers_1[@]}"
echo
echo "--== Data set 2 ==--" 
echo "Quartile 1: $q1_2"
echo "Quartile 2: $q2_2"
echo "Quartile 3: $q3_2"
echo "Lower extreme: $lower_extreme_2"
echo "Upper extreme: $upper_extreme_2"
echo "Average: $average_display_2"
echo "Standard Deviation: $stdev_display_2"
echo "90% confidence interval: ${interval_90_2[0]} - ${interval_90_2[1]}"
echo "95% confidence interval: ${interval_95_2[0]} - ${interval_95_2[1]}"
echo "99% confidence interval: ${interval_99_2[0]} - ${interval_99_2[1]}"
echo "99.9% confidence interval: ${interval_999_2[0]} - ${interval_999_2[1]}"
echo "Outliers: ${outliers_2[@]}"