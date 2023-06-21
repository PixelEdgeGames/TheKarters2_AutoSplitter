state("TheKarters2") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
}

init
{
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
	{
		var asd = mono["AutosplitData"]; // Get class `AutosplitData` from `Assembly-CSharp`.

		// vars.Helper["ChallengeNrText"] = asd.MakeString("strChallengeNrText");
		// vars.Helper["ChallengeNr"] = asd.Make<int>("iChallengeNr");
		// vars.Helper["TrackName"] = asd.MakeString("strTrackName");

		// vars.Helper["ChallengeCupRoundNr"] = asd.Make<int>("iChallengeCupRoundNr");
		// vars.Helper["ChallengeCupRoundsCount"] = asd.Make<int>("iChallengeCupRoundsCount");

		vars.Helper["TotalPlaytime"] = asd.Make<float>("totalPlaytime");
		// vars.Helper["TestTime"] = asd.Make<float>("testTime");
		vars.Helper["FinishedSuccessfully"] = asd.Make<bool>("bFinishedSuccessfully");
		vars.Helper["IsRaceRunning"] = asd.Make<bool>("bIsRaceRunning");
		vars.Helper["bIsPaused"] = asd.Make<bool>("bIsPaused");
		vars.Helper["RaceTime"] = asd.Make<float>("fRaceTime");
		// vars.Helper["Lap1Time"] = asd.Make<float>("fLap1Time");
		// vars.Helper["Lap2Time"] = asd.Make<float>("fLap2Time");
		// vars.Helper["Lap3Time"] = asd.Make<float>("fLap3Time");

		return true;
	});
}

start
{
        return !old.IsRaceRunning && current.IsRaceRunning;
}

split
{
	// If you finished the final level, that's the final split
	if (!old.FinishedSuccessfully && current.FinishedSuccessfully) // level 101's index is 100.
	{
		// return true;
	}
	
	return false;
}

reset 
{
	/* If you're in the main menu with a playtime of 0, you probably just reset your save file,
	* and you definitely aren't in a current run, so reset the timer.
	*/
	return old.TotalPlaytime > 0f && current.TotalPlaytime == 0f;
}

isLoading
{
	return !current.IsRaceRunning || current.RaceTime == 0 || current.bIsPaused == true;
}
