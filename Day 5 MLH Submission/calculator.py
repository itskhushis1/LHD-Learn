'''
From MIT OpenCourseWare Intro. to Computational Thinking and Data Science

Create a program to determine the best percentage of salary to save for a three-year
period to generate a 25% down payment for a home. User enters an annual salary.
There is a constant 7% semi-annual raise, 4% rate of return on savings, and 
a home cost of $1,000,000. It is possible, depending on initial salary, that the
user will be unable to save the down payment in the three year period.
'''
# Initialize variables
semi_annual_raise = .07
investment_r = .04
current_savings = 0
total_cost = 1000000
annual_salary = int(input("Enter your initial annual salary: ")) 
down_payment = total_cost*.25
epsilon = 100
low = 0
high = 10000  
guess = (high + low)//2
savings_rate = ((high + low)/2.0)/10000
monthly_savings = (annual_salary/12)*savings_rate

def calcSavings (salary, rate):
    global current_savings # Tell python to use global variable in function
    global monthly_savings # Tell python to use global variable in function
    
    # Super important: have to re-set monthly savings based on initial salary 
    # and new savings rate
    monthly_savings = (annual_salary/12)*rate
    
    # Calculate current savings over 36 months                       
    for month in range(1,37):
        
        # Add semi-annual raise to salary and adjust monthly savings accordingly
        if (month % 6 == 0):
            salary += salary*semi_annual_raise
            monthly_savings = (salary/12)*rate
        
        # Add monthly savings to current savings every month
        current_savings += monthly_savings
        
        # Add investment income to current savings every month
        current_savings += current_savings*investment_r/12 

    return current_savings

# Call calcSavings with initial annual salary and initial savings rate 
calcSavings(annual_salary, savings_rate)

# At savings rate of 100%, if current savings is >= to zero, then start bisection
# else (see far below) return error. If saving 100% of income over 3 years doesn't 
# produce more than the down payment, then there is no way to save that much in 3 years.
if ((calcSavings(annual_salary, 1.00)) - down_payment) >= 0:
    
    # Initialize bisection step counter
    bisection_steps = 0 

    # Check to see how close current savings is to the down payment by subtracting the two. 
    # If the difference is greater than our target difference of 100 (epsilon), then we need 
    # to find a new savings rate using bisection.
    while abs((current_savings - down_payment)) >= epsilon:  
        
        # If current savings is less than down payment, then the savings rate needs to be larger. 
        # To get a larger savings rate, we have to reset the low value to the current value of the 
        # savings rate because we already know that this current savings rate is too low 
        # (because it's producing too little savings). 
        if current_savings < down_payment:
            low = guess
        
        # Otherwise, if the current savings is greater than the down_payment, then we need to 
        # reduce the savings rate. To get a smaller savings rate, we reset the high value to the 
        # current savings rate because we know the current value of the savings rate is too high 
        # (because it's producing too much savings).
        else:
            high = guess
        
        # Calculate new guess for bisection search
        guess = (high + low)//2
        
        # Calculate new savings rate to use in calculating current savings
        savings_rate = ((high + low)/2.0)/10000
        
        # Increment the counter which is tracking number of bisection steps
        bisection_steps += 1
        
        # Reset current_savings to 0
        current_savings = 0
        
        # Call calcSavings function with original annual_salary and new savings_rate
        calcSavings(annual_salary, savings_rate)
         
    #print("Current Savings:", current_savings)
    #print("Down payment required:", down_payment)
    print("Best savings rate:", savings_rate) 
    print("Steps in bisection search:", bisection_steps)  
else:
    print("It is not possible to pay the down payment in three years.")

#### Tests ####
###############
#Test case 1:
#Enter the starting salary: 150000
#Expect Best savings rate: 0.4411  
#Expect Steps in bisection search: 12 

#Test case 2:
#Enter the starting salary: 300000
#Expect Best savings rate: 0.2206 
#Expect Steps in bisection search: 9 

#Test case 3: 
#Enter the starting salary: 10000
#Expect It is not possible to pay the down payment in three years.