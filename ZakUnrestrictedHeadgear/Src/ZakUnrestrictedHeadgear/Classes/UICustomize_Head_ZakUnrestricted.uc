//---------------------------------------------------------------------------------------

class UICustomize_Head_ZakUnrestricted extends UICustomize_Head;

simulated function CreateDataListItems()
{
	local EUIState ColorState;
	local bool bIsObstructed;
	local bool bIsSuppressed; // Issue #219, bIsSuppressed => bIsObstructed (implication)
	local int i;

	// FACE
	//-----------------------------------------------------------------------------------------
	ColorState = bIsSuperSoldier ? eUIState_Disabled : eUIState_Normal;
	GetListItem(i++)
		.UpdateDataValue(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_Face)$ m_strFace, CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Face, ColorState, FontSize), CustomizeFace)
		.SetDisabled(bIsSuperSoldier, m_strIsSuperSoldier);

	// HAIRSTYLE
	//-----------------------------------------------------------------------------------------
	bIsObstructed = XComHumanPawn(CustomizeManager.ActorPawn).SuppressHairstyle(); // Issue #219
	bIsSuppressed = class'CHHelpers'.default.HeadSuppressesHair.Find(XComHumanPawn(CustomizeManager.ActorPawn).HeadContent.Name) > INDEX_NONE; // Issue #219
	ColorState = (bIsSuperSoldier || bIsObstructed) ? eUIState_Disabled : eUIState_Normal;

	GetListItem(i++)
		.UpdateDataValue(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_Hairstyle)$ m_strHair, CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Hairstyle, ColorState, FontSize), CustomizeHair)
		.SetDisabled(bIsSuperSoldier || bIsObstructed, bIsSuperSoldier ? m_strIsSuperSoldier : (bIsSuppressed ? m_strChangeFace : m_strRemoveHelmet)); // Issue #219

	// HAIR COLOR
	//----------------------------------------------------------------------------------------
	// Start Issue #219
	bIsObstructed = XComHumanPawn(CustomizeManager.ActorPawn).SuppressHairstyle() &&
		(CustomizeManager.UpdatedUnitState.kAppearance.iGender == eGender_Female || XComHumanPawn(CustomizeManager.ActorPawn).SuppressBeard());
	bIsSuppressed = class'CHHelpers'.default.HeadSuppressesHair.Find(XComHumanPawn(CustomizeManager.ActorPawn).HeadContent.Name) > INDEX_NONE &&
		(CustomizeManager.UpdatedUnitState.kAppearance.iGender == eGender_Female || class'CHHelpers'.default.HeadSuppressesBeard.Find(XComHumanPawn(CustomizeManager.ActorPawn).HeadContent.Name) > INDEX_NONE);
	// End Issue #219
	ColorState = bIsObstructed ? eUIState_Disabled : eUIState_Normal;

	GetListItem(i++)
		.UpdateDataColorChip(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_HairColor)$ m_strHairColor, CustomizeManager.GetCurrentDisplayColorHTML(eUICustomizeCat_HairColor), HairColorSelector)
		.SetDisabled(bIsSuperSoldier || bIsObstructed, bIsSuperSoldier ? m_strIsSuperSoldier : (bIsSuppressed ? m_strChangeFace : m_strRemoveHelmet)); // Issue #219

	ColorState = bIsSuperSoldier ? eUIState_Disabled : eUIState_Normal;

	// EYE COLOR
	//-----------------------------------------------------------------------------------------
	GetListItem(i++)
		.UpdateDataColorChip(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_EyeColor)$m_strEyeColor, CustomizeManager.GetCurrentDisplayColorHTML(eUICustomizeCat_EyeColor), EyeColorSelector)
		.SetDisabled(bIsSuperSoldier, m_strIsSuperSoldier);

	// RACE
	//-----------------------------------------------------------------------------------------
	GetListItem(i++)
		.UpdateDataValue(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_Race)$ m_strRace, CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Race, ColorState, FontSize), CustomizeRace)
		.SetDisabled(bIsSuperSoldier, m_strIsSuperSoldier);

	// SKIN COLOR
	//-----------------------------------------------------------------------------------------
	GetListItem(i++)
		.UpdateDataColorChip(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_Skin)$ m_strSkinColor, CustomizeManager.GetCurrentDisplayColorHTML(eUICustomizeCat_Skin), SkinColorSelector)
		.SetDisabled(bIsSuperSoldier, m_strIsSuperSoldier);

	// HELMET
	//-----------------------------------------------------------------------------------------
	bIsObstructed = XComHumanPawn(CustomizeManager.ActorPawn).SuppressHelmet(); // Issue #219
	GetListItem(i++)
		.UpdateDataValue(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_Helmet) $ m_strHelmet, CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Helmet, ColorState, FontSize), CustomizeHelmet)
		.SetDisabled(bIsSuperSoldier || bIsObstructed, bIsSuperSoldier ? m_strIsSuperSoldier : m_strChangeFace); // Issue #219

	// UPPER FACE PROPS
	//-----------------------------------------------------------------------------------------
	bIsObstructed = XComHumanPawn(CustomizeManager.ActorPawn).SuppressUpperFaceProp(); // Issue #219
	bIsSuppressed = class'CHHelpers'.default.HeadSuppressesUpperFaceProp.Find(XComHumanPawn(CustomizeManager.ActorPawn).HeadContent.Name) > INDEX_NONE; // Issue #219
	ColorState = bIsObstructed ? eUIState_Disabled : eUIState_Normal;

	GetListItem(i++, bIsObstructed, bIsSuppressed ? m_strChangeFace : m_strRemoveHelmet).UpdateDataValue(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_FaceDecorationLower) $ m_strUpperFaceProps,
		CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_FaceDecorationLower, ColorState, FontSize), CustomizeLowerFaceProps); // Issue #219

	// LOWER FACE PROPS
	//-----------------------------------------------------------------------------------------
	bIsObstructed = XComHumanPawn(CustomizeManager.ActorPawn).SuppressLowerFaceProp(); // Issue #219
	bIsSuppressed = class'CHHelpers'.default.HeadSuppressesLowerFaceProp.Find(XComHumanPawn(CustomizeManager.ActorPawn).HeadContent.Name) > INDEX_NONE; // Issue #219
	ColorState = bIsObstructed ? eUIState_Disabled : eUIState_Normal;

	GetListItem(i++, bIsObstructed, bIsSuppressed ? m_strChangeFace : m_strRemoveHelmet).UpdateDataValue(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_FaceDecorationLower) $ m_strLowerFaceProps, // Issue #219
		CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_FaceDecorationLower, ColorState, FontSize), CustomizeLowerFaceProps);

	// FACIAL HAIR
	//-----------------------------------------------------------------------------------------
	if (CustomizeManager.ShowMaleOnlyOptions())
	{
		bIsObstructed = XComHumanPawn(CustomizeManager.ActorPawn).SuppressBeard(); // Issue #219
		bIsSuppressed = class'CHHelpers'.default.HeadSuppressesBeard.Find(XComHumanPawn(CustomizeManager.ActorPawn).HeadContent.Name) > INDEX_NONE; // Issue #219
		ColorState = (bIsSuperSoldier || bIsObstructed) ? eUIState_Disabled : eUIState_Normal;

		GetListItem(i++)
			.UpdateDataValue(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_FacialHair)$m_strFacialHair, CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_FacialHair, ColorState, FontSize), CustomizeFacialHair)
			.SetDisabled(bIsSuperSoldier || bIsObstructed, bIsSuperSoldier ? m_strIsSuperSoldier : (bIsSuppressed ? m_strChangeFace : m_strRemoveHelmetOrLowerProp)); // Issue #219
	}

	// FACE PAINT
	//-----------------------------------------------------------------------------------------

	//Check whether any face paint is available...
	if (CustomizeManager.HasPartsForPartType("Facepaint", `XCOMGAME.SharedBodyPartFilter.FilterAny))
	{
		GetListItem(i++).UpdateDataValue(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_FacePaint) $ m_strFacePaint,
			CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_FacePaint, eUIState_Normal, FontSize), CustomizeFacePaint);
	}

	// SCARS (VETERAN ONLY)
	//-----------------------------------------------------------------------------------------
	GetListItem(i++, bDisableVeteranOptions).UpdateDataValue(CustomizeManager.CheckForAttentionIcon(eUICustomizeCat_Scars) $ m_strScars,
		CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Scars, ColorState, FontSize), CustomizeScars);

	if (!CustomizeManager.ShowMaleOnlyOptions())
	{
		//bsg-crobinson (5.23.17): If soldier is a female, remove an index to make up for the additional male index
		GetListItem(i--).Remove();
	}
}