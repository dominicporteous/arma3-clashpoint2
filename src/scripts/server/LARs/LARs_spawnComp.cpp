class LARs_spawnComp {
	tag = "LARs";
	class Compositions {
		file = "scripts\server\LARs\functions";
		class createComp{};
		class spawnComp{};
	};
	class Compositions_debug
	{
		file = "scripts\server\LARs\functions\debug";
		class drawBounds{};
	};
	class Compositions_utilities
	{
		file = "scripts\server\LARs\functions\Utilities";
		class deleteComp{};
		class getCompObjects{};
		class getCompItem{};
		class getItemComp{};
	};
};