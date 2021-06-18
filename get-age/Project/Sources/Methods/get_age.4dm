//%attributes = {}
C_DATE:C307($1; $birthDate; $2; $currentDate)
C_LONGINT:C283($years; $months; $days)
C_OBJECT:C1216($0; $status)

$status:=New object:C1471("years"; Null:C1517; "months"; Null:C1517; "days"; Null:C1517)

$currentDate:=$1
$birthDate:=$2

$birthYear:=Year of:C25($birthDate)
$birthMonth:=Month of:C24($birthDate)
$birthDay:=Day of:C23($birthDate)

$currentYear:=Year of:C25($currentDate)
$currentMonth:=Month of:C24($currentDate)
$currentDay:=Day of:C23($currentDate)

/*

problem: 

what if birthday is feb 29 and feb current year does not have 29 days? 
according to this calculation, the age should be incremented on mar 1

*/

$thisBirthDay:=Add to date:C393(!00-00-00!; $currentYear; $birthMonth; $birthDay)

//get years and months
$years:=$currentYear-$birthYear
$months:=$currentMonth-$birthMonth

Case of 
	: (Month of:C24($birthDate)=2) & (Month of:C24($thisBirthDay)=3) & ($currentDate=$thisBirthDay)
		//today=birthday this year=mar 1, birthday is feb 29
		$months:=0
		$days:=0
	: (Month of:C24($birthDate)=2) & (Month of:C24($thisBirthDay)=3) & ($currentDate>$thisBirthDay) & ($currentMonth=3)
		//birthday this year is in the past, birthday is feb 29, current year is not leap
		$months:=0
		$days:=$currentDay-1
	: (Month of:C24($birthDate)=2) & (Month of:C24($thisBirthDay)=3) & ($currentMonth=1)
		//birthday this year is in the future, birthday is feb 29, current year is not leap, count days from previous month=dec
		$years:=$years-1
		$months:=$months+12
		$days:=$currentDate-Add to date:C393(!00-00-00!; $currentYear-1; 12; $birthDay)
	: (Month of:C24($birthDate)=2) & (Month of:C24($thisBirthDay)=3)
		//birthday this year is in the past, birthday is feb 29, current year is not leap, count days from previous month
		$days:=$currentDate-Add to date:C393(!00-00-00!; $currentYear; $currentMonth-1; $birthDay)
	: ($currentDate<$thisBirthDay) & ($birthDay>$currentDay) & ($currentMonth=1)
		//birthday this year is in the future, count days from previous month=dec
		$years:=$years-1
		$months:=$months+11
		$days:=$currentDate-Add to date:C393(!00-00-00!; $currentYear-1; 12; $birthDay)
	: ($currentDate<$thisBirthDay) & ($birthDay>$currentDay)
		//birthday this year is in the future, count days from previous month
		$years:=$years-1
		$months:=$months+11
		$days:=$currentDate-Add to date:C393(!00-00-00!; $currentYear; $currentMonth-1; $birthDay)
	: ($currentDate<$thisBirthDay)
		//birthday this year is in the future, count days from current month
		$years:=$years-1
		$months:=$months+12
		$days:=$currentDay-$birthDay
	: ($currentDate=$thisBirthDay)
		//today=birthday 
		$months:=0
		$days:=0
	: ($birthDay>$currentDay) & ($currentMonth=1)
		//birthday this year is in the past, count days from previous month=dec
		$months:=$months-1
		$days:=$currentDate-Add to date:C393(!00-00-00!; $currentYear; $currentMonth-1; $birthDay)
	: ($birthDay>$currentDay)
		//birthday this year is in the past, count days from previous month
		$months:=$months-1
		$days:=$currentDate-Add to date:C393(!00-00-00!; $currentYear; $currentMonth-1; $birthDay)
	Else 
		//birthday this year is in the past, count days from current month
		$months:=$months-1
		$days:=$currentDay-$birthDay
End case 

$status.years:=$years
$status.months:=$months
$status.days:=$days

$0:=$status