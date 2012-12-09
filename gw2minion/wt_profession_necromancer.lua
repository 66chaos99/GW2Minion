-- This file contains Necromancer specific combat routines

-- load routine only if player is a Necromancer
if ( 8 ~= Player.profession ) then
	return
end
-- The following values have to get set ALWAYS for ALL professions!!
wt_profession_necromancer  =  inheritsFrom( nil )
wt_profession_necromancer.professionID = 8 -- needs to be set
wt_profession_necromancer.professionRoutineName = "Necromancer"
wt_profession_necromancer.professionRoutineVersion = "1.0"
wt_profession_necromancer.RestHealthLimit = 70


wt_profession_necromancer.petIDs = {
    10547, -- Blood Fiend
    10589, -- Shadow Fiend
    10533, -- Bone Fiend
    10541, -- Bone Minions
    10646, -- Flesh Golem
}
wt_profession_necromancer.Slots = {
	GW2.SKILLBARSLOT.Slot_6,
	GW2.SKILLBARSLOT.Slot_7,
	GW2.SKILLBARSLOT.Slot_8,
	GW2.SKILLBARSLOT.Slot_9,
	GW2.SKILLBARSLOT.Slot_10,
}
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-- NeedHeal Check
wt_profession_necromancer.c_heal_action = inheritsFrom(wt_cause)
wt_profession_necromancer.e_heal_action = inheritsFrom(wt_effect)

function wt_profession_necromancer.c_heal_action:evaluate()
	return (Player.health.percent < 50 and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_6))
end
wt_profession_necromancer.e_heal_action.usesAbility = true

function wt_profession_necromancer.e_heal_action:execute()
	wt_debug("e_heal_action")
	Player:CastSpell(GW2.SKILLBARSLOT.Slot_6)
end

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-- NeedHeal Check
wt_profession_necromancer.c_pets = inheritsFrom(wt_cause)
wt_profession_necromancer.e_pets = inheritsFrom(wt_effect)

function wt_profession_necromancer.c_pets:evaluate()	
	if (not Player.incombat ) then 
		for index1, ID in pairs(wt_profession_necromancer.petIDs) do
			for index2, slot in pairs(wt_profession_necromancer.Slots) do
				SpellInfo = Player:GetSpellInfo(slot)
				if (SpellInfo ~= nil) then
					if (ID == SpellInfo.skillID and not Player:IsSpellOnCooldown(slot)) then
						return true
					end
				end
			end
		end
	end
	return false
end

wt_profession_necromancer.e_pets.usesAbility = true
function wt_profession_necromancer.e_pets:execute()
	for index1, ID in pairs(wt_profession_necromancer.petIDs) do
		for index2, slot in pairs(wt_profession_necromancer.Slots) do
			SpellInfo = Player:GetSpellInfo(slot)
			if (SpellInfo ~= nil) then
				if (ID == SpellInfo.skillID and not Player:IsSpellOnCooldown(slot)) then
					Player:CastSpell(slot)
				end
			end
		end
	end
end

------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Move Closer to Target Check
wt_profession_necromancer.c_MoveCloser = inheritsFrom(wt_cause)
wt_profession_necromancer.e_MoveCloser = inheritsFrom(wt_effect)

function wt_profession_necromancer.c_MoveCloser:evaluate()
	if ( wt_core_state_combat.CurrentTarget ~= 0 ) then
		local T = CharacterList:Get(wt_core_state_combat.CurrentTarget)
		local Distance = T ~= nil and T.distance or 0
		local LOS = T~=nil and T.los or false
		if (Distance >= wt_global_information.AttackRange  or LOS~=true) then
			return true
		else
			if( Player:GetTarget() ~= wt_core_state_combat.CurrentTarget) then
				Player:SetTarget(wt_core_state_combat.CurrentTarget)
			end
		end
	end
	return false;
end

function wt_profession_necromancer.e_MoveCloser:execute()
	wt_debug("e_MoveCloser ")
	local T = CharacterList:Get(wt_core_state_combat.CurrentTarget)
	if ( T ~= nil ) then
		Player:MoveTo(T.pos.x,T.pos.y,T.pos.z,120) -- the last number is the distance to the target where to stop
	end
end

------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Update Weapon Data 
wt_profession_necromancer.c_update_weapons = inheritsFrom(wt_cause)
wt_profession_necromancer.e_update_weapons = inheritsFrom(wt_effect)

function wt_profession_necromancer.c_update_weapons:evaluate()
	wt_profession_necromancer.MHweapon = Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.MainHandWeapon)
	wt_profession_necromancer.OHweapon = Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.OffHandWeapon)
	return false
end

function wt_profession_necromancer.e_update_weapons:execute()	
end

------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Combat Default Attack 
wt_profession_necromancer.c_attack_default = inheritsFrom(wt_cause)
wt_profession_necromancer.e_attack_default = inheritsFrom(wt_effect)

function wt_profession_necromancer.c_attack_default:evaluate()
	  return wt_core_state_combat.CurrentTarget ~= 0
end

wt_profession_necromancer.e_attack_default.usesAbility = true
function wt_profession_necromancer.e_attack_default:execute()
	Player:StopMoving()
	TID = wt_core_state_combat.CurrentTarget
	if ( TID ~= 0 ) then
		local T = CharacterList:Get(TID)
		if ( T ~= nil ) then
			wt_debug("attacking " .. TID .. " Distance " .. T.distance)
			Player:SetFacing(T.pos.x-Player.pos.x,T.pos.z-Player.pos.z,T.pos.y-Player.pos.y)
			local s1 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_1)
			local s2 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_2)
			local s3 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_3)
			local s4 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_4)
			local s5 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_5)
			local deathshroud = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_13)
			if (Player.health.percent < 50 and deathshroud ~= nil and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_13) and Player:GetProfessionPowerPercentage() > 25) then
				Player:CastSpell(GW2.SKILLBARSLOT.Slot_13)			
			elseif (s1 ~= nil) then
				wt_global_information.AttackRange = s1.maxRange
				if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_5) and s5~=nil and (T.distance < s5.maxRange or s5.maxRange < 100)) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_5,TID)
				elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_4) and s4~=nil and (T.distance < s4.maxRange or s4.maxRange < 100)) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_4,TID)
				elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_3) and s3~=nil and (T.distance < s3.maxRange or s3.maxRange < 100)) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_3,TID)
				elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_2) and s2~=nil and (T.distance < s2.maxRange or s2.maxRange < 100)) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_2,TID)
				elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_1) and s1~=nil and (T.distance < s1.maxRange or s1.maxRange < 100)) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_1,TID)
				end
			end
		end
	end
end


-----------------------------------------------------------------------------------
-- Registration and setup of causes and effects to the different states
-----------------------------------------------------------------------------------

-- We need to check if the players current profession is ours to only add our profession specific routines
if ( wt_profession_necromancer.professionID > -1 and wt_profession_necromancer.professionID == Player.profession) then

	wt_debug("Initalizing profession routine for Necromancer")
	-- Default Causes & Effects that are already in the wt_core_state_combat for all classes:
	-- Death Check 				- Priority 10000   --> Can change state to wt_core_state_dead.lua
	-- Combat Over Check 		- Priority 500      --> Can change state to wt_core_state_idle.lua
	
	
	-- Our C & E�s for Necromancer combat:
	local ke_heal_action = wt_kelement:create("heal_action",wt_profession_necromancer.c_heal_action,wt_profession_necromancer.e_heal_action, 100 )
		wt_core_state_combat:add(ke_heal_action)
		
	local ke_MoveClose_action = wt_kelement:create("Move closer",wt_profession_necromancer.c_MoveCloser,wt_profession_necromancer.e_MoveCloser, 75 )
		wt_core_state_combat:add(ke_MoveClose_action)
	
	local ke_Update_weapons = wt_kelement:create("UpdateWeaponData",wt_profession_necromancer.c_update_weapons,wt_profession_necromancer.e_update_weapons, 55 )
		wt_core_state_combat:add(ke_Update_weapons)
			
	local ke_Attack_default = wt_kelement:create("Attackdefault",wt_profession_necromancer.c_attack_default,wt_profession_necromancer.e_attack_default, 45 )
		wt_core_state_combat:add(ke_Attack_default)
	
	
	-- C & E`s for Idle state
	
	local ke_checkPets = wt_kelement:create("Summon Pets",wt_profession_necromancer.c_pets,wt_profession_necromancer.e_pets, 95 )
		wt_core_state_idle:add(ke_checkPets)
	

	-- We need to set the Currentprofession to our profession , so that other parts of the framework can use it.
	wt_global_information.Currentprofession = wt_profession_necromancer
	wt_global_information.AttackRange = 450
end
-----------------------------------------------------------------------------------














