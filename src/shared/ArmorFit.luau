-- Fits reviewed, disconnected rigid armor to individual R15 limbs.
-- No imported joints, scripts, collisions or client-owned hitboxes are used.
local Fit = {}
function Fit.equip(template, model, bodyName, name, size, offset)
	local body = assert(model:FindFirstChild(bodyName), "Missing R15 limb: " .. bodyName)
	local group = template:Clone()
	local provenance=template:GetAttribute("RBX_AI_GENERATION_ID") or template.Parent:GetAttribute("RBX_AI_GENERATION_ID")
	if provenance then group:SetAttribute("ZeroSourceGenerationId",provenance) end
	local center, bounds = group:GetBoundingBox()
	local ratio = size / bounds
	for _,p in group:GetDescendants() do
		if p:IsA("BasePart") then
			local localCF = center:ToObjectSpace(p.CFrame)
			p.Size *= ratio
			local special=p:FindFirstChildOfClass("SpecialMesh")
			if special then special.Scale*=ratio end
			p.CFrame = body.CFrame * offset * CFrame.new(localCF.Position * ratio) * localCF.Rotation
			p.Anchored, p.Massless = false, true
			p.CanCollide, p.CanQuery, p.CanTouch = false, false, false
			p.CastShadow = true
			-- Render/collision fidelity is baked into the template in edit time.
			-- Roblox restricts writes to those properties from gameplay scripts.
			p:SetAttribute("ArmorLimb", bodyName)
			local weld = Instance.new("WeldConstraint")
			weld.Name, weld.Part0, weld.Part1, weld.Parent = "ArmorMount", body, p, p
		end
	end
	group.Name, group.Parent = name, model
	return group
end
return Fit
