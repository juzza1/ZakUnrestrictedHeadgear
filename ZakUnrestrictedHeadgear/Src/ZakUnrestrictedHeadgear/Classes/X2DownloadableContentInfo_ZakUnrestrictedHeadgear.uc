class X2DownloadableContentInfo_ZakUnrestrictedHeadgear extends X2DownloadableContentInfo;

// Disable upper/lower prop hiding for all helmets
static function UpdateAnimations(out array<AnimSet> CustomAnimSets, XComGameState_Unit UnitState, XComUnitPawn Pawn)
{
	local XComHumanPawn HumanPawn;
	
	HumanPawn = XComHumanPawn(Pawn);
	if (HumanPawn != none && HumanPawn.HelmetContent != none)
	{
		HumanPawn.HelmetContent.bHideUpperFacialProps = false;
		HumanPawn.HelmetContent.bHideLowerFacialProps = false;
		//`LOG("Updated some facial props???");
	}
}

// Helper function for template copying
static function CopyTemplates(string SrcBodyPart, string DestBodyPart)
{
	local array<X2BodyPartTemplate> TemplateList;
	local int Index;
   
	class'X2BodyPartTemplateManager'.static.GetBodyPartTemplateManager().GetUberTemplates(SrcBodyPart, TemplateList);
	for (Index = 0; Index < TemplateList.Length; ++Index) 
    {
		class'X2BodyPartTemplateManager'.static.GetBodyPartTemplateManager().AddUberTemplate(DestBodyPart, TemplateList[Index], true);
		`LOG("Added" @ SrcBodyPart @ TemplateList[Index].ArchetypeName @ "to" @ DestBodyPart);
    }
}

static event OnPostTemplatesCreated()
{
	local X2CharacterTemplate CharacterTemplate;
    local array<X2BodyPartTemplate> HelmetTemplateList;
	local int Index;
	local array<name> EmptySetNames;

    // something
	/*CharacterTemplate = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager().FindCharacterTemplate('Soldier');
	if (CharacterTemplate != none) {
        `LOG("Overwrote soldier ui head customization");
		CharacterTemplate.UICustomizationHeadClass = class'UICustomize_Head_ZakUnrestricted';
	}*/

	// Replace skirmisher head UI to allow upper face props
	CharacterTemplate = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager().FindCharacterTemplate('SkirmisherSoldier');
	if (CharacterTemplate != none) {
		CharacterTemplate.UICustomizationHeadClass = class'UICustomize_SkirmisherHead_ZakUnrestricted';
	}

	// Remove veterancy, tech, class requirements (unused anyways?) and set requirements from templates
	class'X2BodyPartTemplateManager'.static.GetBodyPartTemplateManager().GetUberTemplates("Helmets", HelmetTemplateList);
	EmptySetNames.AddItem('');
    for (Index = 0; Index < HelmetTemplateList.Length; ++Index) 
    {
		HelmetTemplateList[Index].bVeteran = false;
		HelmetTemplateList[Index].Tech = '';
		HelmetTemplateList[Index].ReqClass = '';
		HelmetTemplateList[Index].SetNames = EmptySetNames;
    }
    
	// Copy helmet/prop templates (RIP sorting...)
	CopyTemplates("FacePropsUpper", "Helmets");
	CopyTemplates("FacePropsLower", "Helmets");
	CopyTemplates("Helmets", "FacePropsUpper");
	CopyTemplates("Helmets", "FacePropsLower");
    
}