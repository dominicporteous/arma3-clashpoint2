class Params
{
	class RoundDuration{
		title = "Round duration";
		values[] = {180,300,450,600,900,1200,1800};
		texts[] = {"3 minutes","5 minutes","7.5 minutes","10 minutes","15 minutes","20 minutes","30 minutes"};
		default = 600;
	};
	class Units{
		title = "Units";
		values[] = {0,1,2,3,4};
		texts[] = {
			"NATO vs CSAT vs AAF (Vanilla)",
			"Gendarmerie vs FIA vs Syndikat (Vanilla)",
			"USA vs Russia vs Nationalists (RHS)",
			"USA vs VC vs ARVN (Unsung)",
			"Wehrmacht vs USSR vs US Army (IFA3)"
		};
		default = 0;
	};
	class DayAndNight{
		title = "Time of Day";
		values[] = {0,1,2};
		texts[] = {"Random","Day","Night"};
		default = 0;
	};
	class WeatherParam{
		title = "Weather";
		values[] = {0,1};
		texts[] = {"Always Clear","Random"};
		default = 0;
	};
	class AiGroups{
		title = "Max Number of AI Groups per side";
		values[] = {1,2,3,4,5,6,7,8,9,10};
		texts[] = {"1","2","3","4","5","6","7","8","9","10"};
		default = 3;
	};
	class MaxAi{
		title = "Max Number of Recruitable AI";
		values[] = {1,2,3,4,5,6,7,8};
		texts[] = {"1","2","3","4","5","6","7","8"};
		default = 5;
	};
	class Support{
		title = "Support Enabled";
		values[] = {0,1};
		texts[] = {"No","Yes"};
		default = 1;
	};
	class Stamina{
		title = "Stamina Enabled";
		values[] = {0,1};
		texts[] = {"No","Yes"};
		default = 0;
	};
};

