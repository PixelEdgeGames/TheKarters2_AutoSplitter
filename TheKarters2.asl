state("TheKarters2") {}

startup
{
    vars.Log = (Action<object>)(output => print("[] " + output));
    vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
}

init
{
    vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
    {
        var myClass = helper.GetClass("Assembly-CSharp", "AutosplitData");

        vars.Unity.MakeString(myClass.Static, myClass["strChallengeNrText"]).Name = "strChallengeNrText";
        vars.Unity.Make<int>(myClass.Static, myClass["iChallengeNr"]).Name = "iChallengeNr";
        vars.Unity.MakeString(myClass.Static, myClass["strTrackName"]).Name = "strTrackName";
		
        vars.Unity.Make<int>(myClass.Static, myClass["iChallengeCupRoundNr"]).Name = "iChallengeCupRoundNr";
        vars.Unity.Make<int>(myClass.Static, myClass["iChallengeCupRoundsCount"]).Name = "iChallengeCupRoundsCount";
        
        vars.Unity.Make<float>(myClass.Static, myClass["totalPlaytime"]).Name = "totalPlaytime";
        vars.Unity.Make<float>(myClass.Static, myClass["testTime"]).Name = "testTime";
        vars.Unity.Make<bool>(myClass.Static, myClass["bFinishedSuccessfully"]).Name = "bFinishedSuccessfully";
        vars.Unity.Make<bool>(myClass.Static, myClass["bIsRaceRunning"]).Name = "bIsRaceRunning";
        vars.Unity.Make<float>(myClass.Static, myClass["fRaceTime"]).Name = "fRaceTime";
        vars.Unity.Make<float>(myClass.Static, myClass["fLap1Time"]).Name = "fLap1Time";
        vars.Unity.Make<float>(myClass.Static, myClass["fLap2Time"]).Name = "fLap2Time";
        vars.Unity.Make<float>(myClass.Static, myClass["fLap3Time"]).Name = "fLap3Time";

        return true;
    });

    vars.Unity.Load(game);
}

update
{
    if (!vars.Unity.Loaded) return false;

    vars.Unity.Update();
}

start
{
        return vars.Unity["bIsRaceRunning"].Current;
}

split
{
	// If you finished the final level, that's the final split
	if (vars.Unity["bFinishedSuccessfully"].Changed && vars.Unity["bFinishedSuccessfully"].Current == true) // level 101's index is 100.
	{
		//return true;
	}
	
	return false;
}

isLoading
{
    return vars.Unity["bIsRaceRunning"].Current == false || vars.Unity["fRaceTime"].Changed == false  || vars.Unity["fRaceTime"].Current == 0;
}



reset 
{
    /* If you're in the main menu with a playtime of 0, you probably just reset your save file,
    * and you definitely aren't in a current run, so reset the timer.
    */
    return vars.Unity["totalPlaytime"].Current == 0;
}

exit
{
    vars.Unity.Reset();
}

shutdown
{
    vars.Unity.Reset();
}
