--[[


 ________  ___  ________   ___  __            ___    ___ 
|\   __  \|\  \|\   ___  \|\  \|\  \         |\  \  /  /|
\ \  \|\  \ \  \ \  \\ \  \ \  \/  /|_       \ \  \/  / /
 \ \   ____\ \  \ \  \\ \  \ \   ___  \       \ \    / / 
  \ \  \___|\ \  \ \  \\ \  \ \  \\ \  \       /     \/  
   \ \__\    \ \__\ \__\\ \__\ \__\\ \__\     /  /\   \  
    \|__|     \|__|\|__| \|__|\|__| \|__|    /__/ /\ __\ 
                                             |__|/ \|__| 
                                                         
                  


   
]]

function getMouseTarget()
	local cursorPosition = game:GetService("UserInputService"):GetMouseLocation()
	print'pen'
	return workspace:FindPartOnRayWithIgnoreList(Ray.new(workspace.CurrentCamera.CFrame.p,(workspace.CurrentCamera:ViewportPointToRay(cursorPosition.x, cursorPosition.y, 0).Direction * 1000)),game.Players.LocalPlayer.Character:GetDescendants())
end
local droppedCounter = 0
function dirtBaseDropInstant(v, baseCFrame, woodClass, itemName)
    local remote = game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedStructure
    remote.Name = game:GetService("HttpService"):GenerateGUID(false)
    remote:FireServer((itemName or nil), baseCFrame, game.Players.LocalPlayer, (woodClass or nil), v, true)
    wait(0.04)
    remote.Name = "ClientPlacedStructure"
end
function dropMeme(aasas,CFrame)
    for i,v in pairs (workspace.PlayerModels:children()) do
        if v:FindFirstChild'Owner' and (v:FindFirstChild"ItemName" or v:FindFirstChild"PurchasedBoxItemName") then
            local nm = v:FindFirstChild"ItemName" or v:FindFirstChild"PurchasedBoxItemName"
            if v.Owner.Value == game.Players.LocalPlayer and nm.Value == aasas then
                dirtBaseDropInstant(v,(CFrame or v.PrimaryPart.CFrame-Vector3.new(0,.1,0)))
            end
        end
    end
end

function HardDragger()
	_G.HardDraggerToggle = false
	local player = game.Players.LocalPlayer
	local Character = player.Character or player.CharacterAdded:wait()
	local Humanoid = Character:WaitForChild("Humanoid")
	local walkSpeed = Humanoid.WalkSpeed
	local userInputService = game:GetService("UserInputService")
	game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger.Disabled = true
	screnGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
	_G.dragRangeMin = 5
	fivefour = coroutine.wrap(function()
	EKey = false
	QKey = false
	player:GetMouse().KeyDown:connect(function(key)
		if string.lower(key) == "e" then
			EKey = true
		elseif string.lower(key) == "q" then
			QKey = true
		end
	end)
	player:GetMouse().KeyUp:connect(function(key)
		if string.lower(key) == "e" then
			EKey = false
		elseif string.lower(key) == "q" then
			QKey = false
		end
	end)
	local keyA = false
	local keyD = false
	local keyW = false
	local keyS = false
	function getThrottleFromKeys()
		local throttle = 0
		if keyS then
			throttle = throttle - 1
		end
		if keyW then
			throttle = throttle + 1
		end
		return throttle
	end

	function getSteerFromKeys()
		local steer = 0
		
		if keyA then
			steer = steer - 1
		end
		if keyD then
			steer = steer + 1
		end
		return steer
	end

	function setKey(input)
		if input.KeyCode == Enum.KeyCode.A then
			keyA = input.UserInputState == Enum.UserInputState.Begin
		elseif input.KeyCode == Enum.KeyCode.D then
			keyD = input.UserInputState == Enum.UserInputState.Begin
		elseif input.KeyCode == Enum.KeyCode.S then
			keyS = input.UserInputState == Enum.UserInputState.Begin
		elseif input.KeyCode == Enum.KeyCode.W then
			keyW = input.UserInputState == Enum.UserInputState.Begin
		end
	end
	function rotate(func)
		
		local rotating = false
		local rotateSpeed = 0
		
		userInputService.InputBegan:connect(function(input, processed)
			
			if not (input.UserInputType == Enum.UserInputType.Gamepad1 or input.UserInputType == Enum.UserInputType.Keyboard and not processed) then return end

			if input.KeyCode == Enum.KeyCode.ButtonL2 then
				rotateSpeed = input.Position.Z
			elseif input.KeyCode == Enum.KeyCode.LeftShift then
				rotateSpeed = 1
			end
			
			if rotateSpeed > 0 then -- Do rotation
				if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D or input.KeyCode == Enum.KeyCode.LeftShift then
					setKey(input)
					local xRot = getSteerFromKeys() --Eh, h4x
					local yRot = getThrottleFromKeys()
					func(Vector2.new(xRot, yRot), rotateSpeed)
				end		
				
				--Unbind walking if not already
			end
		end)
		
		
		userInputService.InputChanged:connect(function(input, processed)
			
			--if processed then return end
			
			if not (input.UserInputType == Enum.UserInputType.Gamepad1 or input.UserInputType == Enum.UserInputType.Keyboard) then return end

			if input.KeyCode == Enum.KeyCode.ButtonL2 then
				rotateSpeed = input.Position.Z
			end
			
			if rotateSpeed > 0 then -- Do rotation
				if input.KeyCode == Enum.KeyCode.Thumbstick1 then
					func(scaleDeadzone(input.Position), rotateSpeed)
				end		
			end
		end)
		
		userInputService.InputEnded:connect(function(input, processed)
			
			
			if not (input.UserInputType == Enum.UserInputType.Gamepad1 or input.UserInputType == Enum.UserInputType.Keyboard and not processed) then return end

			if input.KeyCode == Enum.KeyCode.ButtonL2 then
				rotateSpeed = input.Position.Z
			elseif input.KeyCode == Enum.KeyCode.LeftShift then
				rotateSpeed = 0
			end
			
			
			if rotateSpeed > 0 then -- Continue rotation
				
				if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D then
					setKey(input)
					local xRot = getSteerFromKeys() --Eh, h4x
					local yRot = getThrottleFromKeys()
					func(Vector2.new(xRot, yRot), rotateSpeed)
				end		
			elseif rotateSpeed == 0 then -- End rotation
				func(Vector2.new(), rotateSpeed)
			end
		end)
		
	end

	while wait(0.1) do
		if EKey then
			F = FVal
			FVal = FVal + 1000
			ChangeForce(F+1000)
		end
		if QKey then
			F = FVal
			FVal = FVal - 1000
			ChangeForce(F-1000)
		end
	end

	end)
	fivefour()
	local dragPart = game.StarterGui.ItemDraggingGUI.Dragger.Dragger:Clone()
	dragPart.Name = "HardDragger"
	dragPart.BrickColor = BrickColor.new("Really red")
	dragPart.Parent = game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger
	--[[local dragPart = Instance.new("Part",game.Players.LocalPlayer.PlayerGui)--game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger.Dragger
	dragPart.Size = Vector3.new(0.2,0.2,0.2)
	dragPart.BrickColor = BrickColor.new("Really red")
	player.CharacterAdded:connect(function()
		Character = player.Character
		Humanoid = Character:WaitForChild("Humanoid")
		Humanoid.Died:connect(function()
			dragPart.Parent = nil
		end)
	end)]]

	--wait(1)
	local dragRangeMax = 10000
	local dragRangeMin = _G.dragRangeMin

	local camera = workspace.CurrentCamera
	local mouse = player:GetMouse()

	local button1Down = false
	local dragRange = dragRangeMax
	FVal = 80000
	local bodyPosition = Instance.new("BodyPosition", dragPart)
	bodyPosition.maxForce = Vector3.new(1, 1, 1) * FVal
	bodyPosition.D = 1000
	bodyPosition.P = 4000
	function ChangeForce(F)
	if F > 0 then
	F = bodyPosition.maxForce.X+F
	bodyPosition.maxForce = Vector3.new(1, 1, 1) * F
	else
	F = bodyPosition.maxForce.X-F
	bodyPosition.maxForce = Vector3.new(1, 1, 1) * F
	end
	end

	local bodyGyro = Instance.new("BodyGyro", dragPart) 
	bodyGyro.maxTorque = Vector3.new(1, 1, 1) * 200 --4000 -- * 0.000012
	bodyGyro.P = 1200
	bodyGyro.D = 140 --15

	--bodyPosition.P = bodyPosition.P * 1/19
	--bodyPosition.D = bodyPosition.D  * 1/19
	--bodyGyro.P = bodyGyro.P * 1/19
	--bodyGyro.D = bodyGyro.D  * 1/19

	local rotateCFrame = CFrame.new()

	local weld = Instance.new("Weld", dragPart)

	--local interactPermission = require(game.ReplicatedStorage.Interaction.InteractionPermission)

	local clientIsDragging = game.ReplicatedStorage.Interaction.ClientIsDragging

	local carryAnimationTrack


	--------------------------------[[ Drag Main ]]------------------------------------

	local draggingPart = false

	function click()
		button1Down = true

		local targetObject = game.Players.LocalPlayer:GetMouse().Target
		if not canDrag(targetObject) then
			return
		end
		
		local mouseHit = game.Players.LocalPlayer:GetMouse().Hit.p
		if (mouseHit - Character.Head.Position).magnitude > dragRangeMax then
			return
		end
		
		initializeDrag(targetObject, mouseHit)
		rotateCFrame = CFrame.new()
		
		carryAnimationTrack:Play(0.1, 1, 1)
		
		local dragIsFailing = 0 
		local dragTime = 0
		
		
		while button1Down and canDrag(targetObject) do
			local desiredPos = Character.Head.Position + (game.Players.LocalPlayer:GetMouse().Hit.p - Character.Head.Position).unit * dragRange
			
			local dragRay = Ray.new(Character.Head.Position, desiredPos - Character.Head.Position)
			local part, pos = workspace:FindPartOnRayWithIgnoreList(dragRay, {Character, dragPart, targetObject.Parent})
			
			if part then
				desiredPos = pos
			end
			
			if (camera.CoordinateFrame.p - Character.Head.Position).magnitude > 2 then
				desiredPos = desiredPos + Vector3.new(0, 1.8, 0)
			end
			
			moveDrag(desiredPos)
			bodyGyro.cframe = CFrame.new(dragPart.Position, camera.CoordinateFrame.p) * rotateCFrame
			
			local targParent = findHighestParent(targetObject) or targetObject		
			
			local attemptingToSurf  = false
			for _, check in pairs({{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0.7, -2.8, 0)).p, Vector3.new(0, -2, 0))}, 
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0.35, -2.8, 0)).p, Vector3.new(0, -2, 0))}, 
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0, -2.8, 0)).p, Vector3.new(0, -2, 0))},
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0.35, -2.8, 0)).p, Vector3.new(0, -2, 0))}, 
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(-0.7, -2.8, 0)).p, Vector3.new(0, -2, 0))}, 
								
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0.35, -2.8, 0.6)).p, Vector3.new(0, -2, 0))}, 
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0, -2.8, 0.6)).p, Vector3.new(0, -2, 0))},
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0.35, -2.8, 0.6)).p, Vector3.new(0, -2, 0))}, 
								
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0.35, -2.8, -0.6)).p, Vector3.new(0, -2, 0))}, 
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0, -2.8, -0.6)).p, Vector3.new(0, -2, 0))},
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0.35, -2.8, -0.6)).p, Vector3.new(0, -2, 0))}, 
								
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0.5, -0.8, 0)).p, Character.HumanoidRootPart.CFrame.lookVector), State = Enum.HumanoidStateType.Climbing},
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(-0.5, -0.8, 0)).p, Character.HumanoidRootPart.CFrame.lookVector), State = Enum.HumanoidStateType.Climbing},
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0.5, -1.3, 0)).p, Character.HumanoidRootPart.CFrame.lookVector), State = Enum.HumanoidStateType.Climbing},
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(-0.5, -1.3, 0)).p, Character.HumanoidRootPart.CFrame.lookVector), State = Enum.HumanoidStateType.Climbing}
										
						}) do
			
				local ray = check.Ray
				local part, _ = workspace:FindPartOnRayWithIgnoreList(ray, {Character})
				local op = part
				part = part and findHighestParent(part)
				
				if part and (not check.State or Humanoid:GetState() == check.State) then
					if part == targParent then
						attemptingToSurf = true
					else
						for _, connectedPart in pairs(op:GetConnectedParts(true)) do

							if connectedPart == targetObject--[[targParent]] then
								attemptingToSurf = true
								break
							end
						end
					end

					if attemptingToSurf then
						break
					end
				end
			end
			
			
			
			
			
			local falling = Humanoid:GetState() == Enum.HumanoidStateType.Freefall or Humanoid:GetState() == Enum.HumanoidStateType.FallingDown--not part1 and not part2
			
			
			if attemptingToSurf then
				dragIsFailing = 0
			elseif falling then
				dragIsFailing = 0
			elseif (dragPart.Position - desiredPos).magnitude > 5 then
				dragIsFailing = 0
			else
				dragIsFailing = 0
			end
			if dragIsFailing > 16 then
				break
			end
			
			
			if dragTime % 10 == 0 and targParent.Parent:FindFirstChild("Type") and targParent.Parent.Type.Value == "Vehicle" and targParent.Parent:FindFirstChild("Main") then
				game.Players.LocalPlayer.PlayerGui.VehicleControl.SetVehicleOwnership:Fire(targParent.Parent.Main)
			end
			
			clientIsDragging:FireServer(targParent.Parent)
			game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(targParent.Parent)
			wait()
			dragTime = 0
		end
		
		carryAnimationTrack:Stop()
		
		endDrag()
	end


	function findHighestParent(child)
		if not child or not child.Parent or child.Parent == workspace then
			return nil
		end
		
		local ret = child.Parent:FindFirstChild("Owner") and child
		return findHighestParent(child.Parent) or ret
	end



	function clickEnded()
		button1Down = false
	end

	function holdDistanceChanged()
		dragRange = dragRangeMax--[[_G.dragRangeMin + (1 - dist) * (dragRangeMax - _G.dragRangeMin)]]
	end


	function canDrag(targetObject)
		
		
		if not (targetObject and not targetObject.Anchored and targetObject.Parent and Humanoid.Health > 0) then -- General conditions
			return false
		end
		
		if targetObject.Name == "LeafPart" then
			return false
		end
		
		local originTargetObject = targetObject
		targetObject = findHighestParent(targetObject) or targetObject
		
		bodyGyro.Parent = dragPart
		
		
		--[[if not (targetObject.Parent:FindFirstChild("Owner") or targetObject.Parent.Parent:FindFirstChild("Owner")) then
			return otherDraggable(targetObject, originTargetObject)
		end]]

		if targetObject.Parent:FindFirstChild("Owner") or targetObject.Parent.Parent:FindFirstChild("Owner") then
			return true
		end
		
		if targetObject.Parent:FindFirstChild("TreeClass") then -- Wood class
			return true
		end
		if targetObject.Parent:FindFirstChild("BoxItemName") then -- Shop items
			return true
		end
		if targetObject.Parent:FindFirstChild("PurchasedBoxItemName") then -- Purchased box items
			return true
		end
		if targetObject.Parent:FindFirstChild("Handle") then -- Tool items
			return true
		end
		
		return otherDraggable(targetObject, originTargetObject)
	end

	function otherDraggable(targetObject, originTargetObject)
		local draggable = targetObject and targetObject.Parent and targetObject.Parent:FindFirstChild("DraggableItem") or originTargetObject and originTargetObject.Parent and originTargetObject.Parent:FindFirstChild("DraggableItem")
		if draggable then -- Other stuff
			if draggable:FindFirstChild("NoRotate") then
				bodyGyro.Parent  = nil
			end
			return true
		end
	end

	function initializeDrag(targetObject,mouseHit)
		draggingPart = true
		mouse.TargetFilter = targetObject and findHighestParent(targetObject) and findHighestParent(targetObject).Parent or targetObject

		dragPart.CFrame = CFrame.new(mouseHit, camera.CoordinateFrame.p)

		weld.Part0 = dragPart
		weld.Part1 = targetObject
		weld.C0 =  CFrame.new(mouseHit,camera.CoordinateFrame.p):inverse() * targetObject.CFrame
		weld.Parent = dragPart
		
		dragPart.Parent = workspace
	end

	function endDrag()
		mouse.TargetFilter = nil
		dragPart.Parent = nil
		draggingPart = false
	end

	--------------------------------[[ Do Prompt ]]------------------------------------


	local dragGuiState = ""
	function interactLoop()
		while not _G.HardDraggerToggle do
			wait()
			
			local newState = ""
			
			local mouseHit = game.Players.LocalPlayer:GetMouse().Hit.p
			local targetObject = game.Players.LocalPlayer:GetMouse().Target
			
			
			if draggingPart then
				newState = "Dragging"
			elseif canDrag(targetObject) and not button1Down and (mouseHit - Character.Head.Position).magnitude < dragRangeMax then
				newState = "Mouseover"
			end
			
			if true then-- not (newState == dragGuiState) then
				dragGuiState = newState
				setPlatformControls()
				
				if dragGuiState == "" then
					game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanDrag.Visible = false
					game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanRotate.Visible = false
				elseif dragGuiState ==  "Mouseover" then
					game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanDrag.Visible = true
					game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanRotate.Visible = false
				elseif dragGuiState ==  "Dragging" then
					game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanDrag.Visible = false
					game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanRotate.Visible = not (bodyGyro.Parent == nil) and (not player:FindFirstChild("IsChatting") or player.IsChatting.Value < 1)
				end
			end
			
		end
		Clcicked:Disconnect()
		unClcicked:Disconnect()
		clickEnded()
		game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanDrag.Visible = false
		game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanRotate.Visible = false
	end


	--------------------------------[[ Drag Moving ]]------------------------------------


	function moveDrag(pos)
		bodyPosition.position = pos
	end
	local rotateSpeedReduce = 0.036

	local lastRotateTick
	function crotate(amount, speed)

		if not draggingPart then
			if not player:FindFirstChild("IsChatting") or player.IsChatting.Value < 2 then
				Humanoid.WalkSpeed = walkSpeed
			end
			return
		end
		
		if Humanoid.WalkSpeed > 1 then
			walkSpeed = Humanoid.WalkSpeed
			Humanoid.WalkSpeed = 0
		end
		
		lastRotateTick = tick()
		local thisRotateTick = lastRotateTick
		
		while draggingPart and amount.magnitude > 0 and lastRotateTick == thisRotateTick do
			rotateCFrame = CFrame.Angles(0, -amount.X * rotateSpeedReduce, 0) * CFrame.Angles(amount.Y * rotateSpeedReduce, 0, 0) * rotateCFrame
			wait()
		end
		
		if amount.magnitude == 0 then
			if not player:FindFirstChild("IsChatting") or  player.IsChatting.Value < 2 then
				Humanoid.WalkSpeed = walkSpeed
			end
		end
	end

	--------------------------------[[ User Input ]]------------------------------------

	--wait(1)

	carryAnimationTrack = Humanoid:LoadAnimation(game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger:WaitForChild("CarryItem"))

	--input = require(game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.Parent:WaitForChild("Scripts"):WaitForChild("UserInput"))
	Clcicked = nil
	Clcicked = game.Players.LocalPlayer:GetMouse().Button1Down:Connect(function()
		--[[if _G.HardDraggerToggle then 
			Clcicked:Disconnect()
			return
		end]]
		click()
		holdDistanceChanged()
	end)
	unClcicked = nil
	unClcicked = game.Players.LocalPlayer:GetMouse().Button1Up:Connect(function()
		--[[if _G.HardDraggerToggle then
			unClcicked:Disconnect()
		end]]
		clickEnded()
	end)
	--input.ClickBegan(click, holdDistanceChanged)
	--input.ClickEnded(clickEnded)

	rotate(crotate)


	function setPlatformControls()
			game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanDrag.PlatformButton.Image = game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanDrag.PlatformButton.PC.Value
			game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanDrag.PlatformButton.KeyLabel.Text = "CLICK"
			game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanRotate.PlatformButton.Image = game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanRotate.PlatformButton.PC.Value
			game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanRotate.PlatformButton.KeyLabel.Text = "SHIFT + WASD"
	end


	interactLoop()
end
function disableHardDragger()
	--Original Hard Dragger
	_G.HardDraggerToggle = true
	local player = game.Players.LocalPlayer
	local Character = player.Character or player.CharacterAdded:wait()
	local Humanoid = Character:WaitForChild("Humanoid")
	local walkSpeed = Humanoid.WalkSpeed
	local userInputService = game:GetService("UserInputService")
	game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger.Disabled = true
	screnGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
	fivefour = coroutine.wrap(function()
	local keyA = false
	local keyD = false
	local keyW = false
	local keyS = false
	function getThrottleFromKeys()
		local throttle = 0
		if keyS then
			throttle = throttle - 1
		end
		if keyW then
			throttle = throttle + 1
		end
		return throttle
	end

	function getSteerFromKeys()
		local steer = 0
		
		if keyA then
			steer = steer - 1
		end
		if keyD then
			steer = steer + 1
		end
		return steer
	end

	function setKey(input)
		if input.KeyCode == Enum.KeyCode.A then
			keyA = input.UserInputState == Enum.UserInputState.Begin
		elseif input.KeyCode == Enum.KeyCode.D then
			keyD = input.UserInputState == Enum.UserInputState.Begin
		elseif input.KeyCode == Enum.KeyCode.S then
			keyS = input.UserInputState == Enum.UserInputState.Begin
		elseif input.KeyCode == Enum.KeyCode.W then
			keyW = input.UserInputState == Enum.UserInputState.Begin
		end
	end
	function rotate(func)
		
		local rotating = false
		local rotateSpeed = 0
		
		userInputService.InputBegan:connect(function(input, processed)
			
			if not (input.UserInputType == Enum.UserInputType.Gamepad1 or input.UserInputType == Enum.UserInputType.Keyboard and not processed) then return end

			if input.KeyCode == Enum.KeyCode.ButtonL2 then
				rotateSpeed = input.Position.Z
			elseif input.KeyCode == Enum.KeyCode.LeftShift then
				rotateSpeed = 1
			end
			
			if rotateSpeed > 0 then -- Do rotation
				if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D or input.KeyCode == Enum.KeyCode.LeftShift then
					setKey(input)
					local xRot = getSteerFromKeys() --Eh, h4x
					local yRot = getThrottleFromKeys()
					func(Vector2.new(xRot, yRot), rotateSpeed)
				end		
				
				--Unbind walking if not already
			end
		end)
		
		
		userInputService.InputChanged:connect(function(input, processed)
			
			--if processed then return end
			
			if not (input.UserInputType == Enum.UserInputType.Gamepad1 or input.UserInputType == Enum.UserInputType.Keyboard) then return end

			if input.KeyCode == Enum.KeyCode.ButtonL2 then
				rotateSpeed = input.Position.Z
			end
			
			if rotateSpeed > 0 then -- Do rotation
				if input.KeyCode == Enum.KeyCode.Thumbstick1 then
					func(scaleDeadzone(input.Position), rotateSpeed)
				end		
			end
		end)
		
		userInputService.InputEnded:connect(function(input, processed)
			
			
			if not (input.UserInputType == Enum.UserInputType.Gamepad1 or input.UserInputType == Enum.UserInputType.Keyboard and not processed) then return end

			if input.KeyCode == Enum.KeyCode.ButtonL2 then
				rotateSpeed = input.Position.Z
			elseif input.KeyCode == Enum.KeyCode.LeftShift then
				rotateSpeed = 0
			end
			
			
			if rotateSpeed > 0 then -- Continue rotation
				
				if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D then
					setKey(input)
					local xRot = getSteerFromKeys() --Eh, h4x
					local yRot = getThrottleFromKeys()
					func(Vector2.new(xRot, yRot), rotateSpeed)
				end		
			elseif rotateSpeed == 0 then -- End rotation
				func(Vector2.new(), rotateSpeed)
			end
		end)
		
	end

	end)
	fivefour()
	local dragPart = game.StarterGui.ItemDraggingGUI.Dragger.Dragger:Clone()
	dragPart.Name = "HardDragger"
	dragPart.Parent = game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger
	--[[local dragPart = Instance.new("Part",game.Players.LocalPlayer.PlayerGui)--game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger.Dragger
	dragPart.Size = Vector3.new(0.2,0.2,0.2)
	dragPart.BrickColor = BrickColor.new("Really red")
	player.CharacterAdded:connect(function()
		Character = player.Character
		Humanoid = Character:WaitForChild("Humanoid")
		Humanoid.Died:connect(function()
			dragPart.Parent = nil
		end)
	end)]]

	--wait(1)
	local dragRangeMax = 11
	local dragRangeMin = 7

	local camera = workspace.CurrentCamera
	local mouse = player:GetMouse()

	local button1Down = false
	local dragRange = dragRangeMax
	local bodyPosition = Instance.new("BodyPosition", dragPart)
	bodyPosition.maxForce = Vector3.new(1, 1, 1) * 17000
	bodyPosition.D = 800
	function ChangeForce(F)
	if F > 0 then
	F = bodyPosition.maxForce.X+F
	bodyPosition.maxForce = Vector3.new(1, 1, 1) * F
	else
	F = bodyPosition.maxForce.X-F
	bodyPosition.maxForce = Vector3.new(1, 1, 1) * F
	end
	end

	local bodyGyro = Instance.new("BodyGyro", dragPart) 
	bodyGyro.maxTorque = Vector3.new(1, 1, 1) * 200 --4000 -- * 0.000012
	bodyGyro.P = 1200
	bodyGyro.D = 140 --15

	--bodyPosition.P = bodyPosition.P * 1/19
	--bodyPosition.D = bodyPosition.D  * 1/19
	--bodyGyro.P = bodyGyro.P * 1/19
	--bodyGyro.D = bodyGyro.D  * 1/19

	local rotateCFrame = CFrame.new()

	local weld = Instance.new("Weld", dragPart)
	unlockmodulescript(game.ReplicatedStorage.Interaction.InteractionPermission)
	local interactPermission = require(game.ReplicatedStorage.Interaction.InteractionPermission)

	local clientIsDragging = game.ReplicatedStorage.Interaction.ClientIsDragging

	local carryAnimationTrack


	--------------------------------[[ Drag Main ]]------------------------------------

	local draggingPart = false

	function click()
		button1Down = true

		local targetObject = game.Players.LocalPlayer:GetMouse().Target
		if not canDrag(targetObject) then
			return
		end
		
		local mouseHit = game.Players.LocalPlayer:GetMouse().Hit.p
		if (mouseHit - Character.Head.Position).magnitude > dragRangeMax then
			return
		end
		
		initializeDrag(targetObject, mouseHit)
		rotateCFrame = CFrame.new()
		
		carryAnimationTrack:Play(0.1, 1, 1)
		
		local dragIsFailing = 0 
		local dragTime = 0
		
		
		while button1Down and canDrag(targetObject) do
			local desiredPos = Character.Head.Position + (game.Players.LocalPlayer:GetMouse().Hit.p - Character.Head.Position).unit * dragRange
			
			local dragRay = Ray.new(Character.Head.Position, desiredPos - Character.Head.Position)
			local part, pos = workspace:FindPartOnRayWithIgnoreList(dragRay, {Character, dragPart, targetObject.Parent})
			
			if part then
				desiredPos = pos
			end
			
			if (camera.CoordinateFrame.p - Character.Head.Position).magnitude > 2 then
				desiredPos = desiredPos + Vector3.new(0, 1.8, 0)
			end
			
			moveDrag(desiredPos)
			bodyGyro.cframe = CFrame.new(dragPart.Position, camera.CoordinateFrame.p) * rotateCFrame
			
			local targParent = findHighestParent(targetObject) or targetObject		
			
			local attemptingToSurf  = false
			for _, check in pairs({{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0.7, -2.8, 0)).p, Vector3.new(0, -2, 0))}, 
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0.35, -2.8, 0)).p, Vector3.new(0, -2, 0))}, 
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0, -2.8, 0)).p, Vector3.new(0, -2, 0))},
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0.35, -2.8, 0)).p, Vector3.new(0, -2, 0))}, 
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(-0.7, -2.8, 0)).p, Vector3.new(0, -2, 0))}, 
								
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0.35, -2.8, 0.6)).p, Vector3.new(0, -2, 0))}, 
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0, -2.8, 0.6)).p, Vector3.new(0, -2, 0))},
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0.35, -2.8, 0.6)).p, Vector3.new(0, -2, 0))}, 
								
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0.35, -2.8, -0.6)).p, Vector3.new(0, -2, 0))}, 
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0, -2.8, -0.6)).p, Vector3.new(0, -2, 0))},
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0.35, -2.8, -0.6)).p, Vector3.new(0, -2, 0))}, 
								
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0.5, -0.8, 0)).p, Character.HumanoidRootPart.CFrame.lookVector), State = Enum.HumanoidStateType.Climbing},
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(-0.5, -0.8, 0)).p, Character.HumanoidRootPart.CFrame.lookVector), State = Enum.HumanoidStateType.Climbing},
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(0.5, -1.3, 0)).p, Character.HumanoidRootPart.CFrame.lookVector), State = Enum.HumanoidStateType.Climbing},
								{Ray = Ray.new((Character.HumanoidRootPart.CFrame * CFrame.new(-0.5, -1.3, 0)).p, Character.HumanoidRootPart.CFrame.lookVector), State = Enum.HumanoidStateType.Climbing}
										
						}) do
			
				local ray = check.Ray
				local part, _ = workspace:FindPartOnRayWithIgnoreList(ray, {Character})
				local op = part
				part = part and findHighestParent(part)
				
				if part and (not check.State or Humanoid:GetState() == check.State) then
					if part == targParent then
						attemptingToSurf = true
					else
						for _, connectedPart in pairs(op:GetConnectedParts(true)) do

							if connectedPart == targetObject--[[targParent]] then
								attemptingToSurf = true
								break
							end
						end
					end

					if attemptingToSurf then
						break
					end
				end
			end
			
			
			
			
			
			local falling = Humanoid:GetState() == Enum.HumanoidStateType.Freefall or Humanoid:GetState() == Enum.HumanoidStateType.FallingDown--not part1 and not part2
			
			
			if attemptingToSurf then
				dragIsFailing = 0
			elseif falling then
				dragIsFailing = 0
			elseif (dragPart.Position - desiredPos).magnitude > 5 then
				dragIsFailing = 0
			else
				dragIsFailing = 0
			end
			if dragIsFailing > 16 then
				break
			end
			
			
			if dragTime % 10 == 0 and targParent.Parent:FindFirstChild("BedInfo") and targParent.Parent:FindFirstChild("Main") then
				--game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.Parent.Scripts.VehicleControl.SetVehicleOwnership:Fire(targParent.Parent.Main)
			end
			
			clientIsDragging:FireServer(targParent.Parent)
			game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(targParent.Parent)
			wait()
			dragTime = 0
		end
		
		carryAnimationTrack:Stop()
		
		endDrag()
	end


	function findHighestParent(child)
		if not child or not child.Parent or child.Parent == workspace then
			return nil
		end
		
		local ret = child.Parent:FindFirstChild("Owner") and child
		return findHighestParent(child.Parent) or ret
	end

	function clickEnded()
		button1Down = false
	end


	function canDrag(targetObject)
		for _, instance in pairs(Character:GetChildren()) do
			if instance:IsA("Tool") then
				return false
			end
		end
		
		
		if not (targetObject and not targetObject.Anchored and targetObject.Parent and Humanoid.Health > 0) then -- General conditions
			return false
		end
		
		if targetObject.Name == "LeafPart" then
			return false
		end
		
		local originTargetObject = targetObject
		targetObject = findHighestParent(targetObject) or targetObject
		
		if game.Players:GetPlayerFromCharacter(targetObject.Parent.Parent) then
			return false
		end
		
		bodyGyro.Parent = dragPart
		
		
		if not targetObject.Parent:FindFirstChild("Owner") then
			return otherDraggable(targetObject, originTargetObject)
		end
		
		if not interactPermission:UserCanInteract(player, targetObject.Parent) then
			return false
		end
		
		if targetObject.Parent:FindFirstChild("TreeClass") then -- Wood class
			return true
		end
		if targetObject.Parent:FindFirstChild("BoxItemName") then -- Shop items
			return true
		end
		if targetObject.Parent:FindFirstChild("PurchasedBoxItemName") then -- Purchased box items
			return true
		end
		if targetObject.Parent:FindFirstChild("Handle") then -- Tool items
			return true
		end
		
		return otherDraggable(targetObject, originTargetObject)
	end

	function otherDraggable(targetObject, originTargetObject)
		local draggable = targetObject and targetObject.Parent and targetObject.Parent:FindFirstChild("DraggableItem") or originTargetObject and originTargetObject.Parent and originTargetObject.Parent:FindFirstChild("DraggableItem")
		if draggable then -- Other stuff
			if draggable:FindFirstChild("NoRotate") then
				bodyGyro.Parent  = nil
			end
			return true
		end
	end

	function initializeDrag(targetObject,mouseHit)
		draggingPart = true
		mouse.TargetFilter = targetObject and findHighestParent(targetObject) and findHighestParent(targetObject).Parent or targetObject

		dragPart.CFrame = CFrame.new(mouseHit, camera.CoordinateFrame.p)

		weld.Part0 = dragPart
		weld.Part1 = targetObject
		weld.C0 =  CFrame.new(mouseHit,camera.CoordinateFrame.p):inverse() * targetObject.CFrame
		weld.Parent = dragPart
		
		dragPart.Parent = workspace
	end

	function endDrag()
		mouse.TargetFilter = nil
		dragPart.Parent = nil
		draggingPart = false
	end

	--------------------------------[[ Do Prompt ]]------------------------------------


	local dragGuiState = ""
	function interactLoop()
		while _G.HardDraggerToggle do
			wait()
			
			local newState = ""
			
			local mouseHit = game.Players.LocalPlayer:GetMouse().Hit.p
			local targetObject = game.Players.LocalPlayer:GetMouse().Target
			
			
			if draggingPart then
				newState = "Dragging"
			elseif canDrag(targetObject) and not button1Down and (mouseHit - Character.Head.Position).magnitude < dragRangeMax then
				newState = "Mouseover"
			end
			
			if true then-- not (newState == dragGuiState) then
				dragGuiState = newState
				setPlatformControls()
				
				if dragGuiState == "" then
					game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanDrag.Visible = false
					game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanRotate.Visible = false
				elseif dragGuiState ==  "Mouseover" then
					game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanDrag.Visible = true
					game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanRotate.Visible = false
				elseif dragGuiState ==  "Dragging" then
					game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanDrag.Visible = false
					game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanRotate.Visible = not (bodyGyro.Parent == nil) and (not player:FindFirstChild("IsChatting") or player.IsChatting.Value < 1)
				end
			end
		end
		Clcicked:Disconnect()
		unClcicked:Disconnect()
		clickEnded()
		game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanDrag.Visible = false
		game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanRotate.Visible = false
	end


	--------------------------------[[ Drag Moving ]]------------------------------------


	function moveDrag(pos)
		bodyPosition.position = pos
	end
	local rotateSpeedReduce = 0.036

	local lastRotateTick
	function crotate(amount, speed)

		if not draggingPart then
			if not player:FindFirstChild("IsChatting") or player.IsChatting.Value < 2 then
				Humanoid.WalkSpeed = walkSpeed
			end
			return
		end
		
		if Humanoid.WalkSpeed > 1 then
			walkSpeed = Humanoid.WalkSpeed
			Humanoid.WalkSpeed = 0
		end
		
		lastRotateTick = tick()
		local thisRotateTick = lastRotateTick
		
		while draggingPart and amount.magnitude > 0 and lastRotateTick == thisRotateTick do
			rotateCFrame = CFrame.Angles(0, -amount.X * rotateSpeedReduce, 0) * CFrame.Angles(amount.Y * rotateSpeedReduce, 0, 0) * rotateCFrame
			wait()
		end
		
		if amount.magnitude == 0 then
			if not player:FindFirstChild("IsChatting") or  player.IsChatting.Value < 2 then
				Humanoid.WalkSpeed = walkSpeed
			end
		end
	end

	--------------------------------[[ User Input ]]------------------------------------

	--wait(1)

	carryAnimationTrack = Humanoid:LoadAnimation(game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger:WaitForChild("CarryItem"))
	Clcicked = nil
	Clcicked = game.Players.LocalPlayer:GetMouse().Button1Down:Connect(function()
		--[[if not _G.HardDraggerToggle then
			Clcicked:Disconnect()
			return
		end]]
		click()
	end)
	unClcicked = nil
	unClcicked = game.Players.LocalPlayer:GetMouse().Button1Up:Connect(function()
		--[[if not _G.HardDraggerToggle then
			unClcicked:Disconnect()
		end]]
		clickEnded()
	end)
	--input = require(game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.Parent:WaitForChild("Scripts"):WaitForChild("UserInput"))
	--input.ClickBegan(click, holdDistanceChanged)
	--input.ClickEnded(clickEnded)

	rotate(crotate)


	function setPlatformControls()
			game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanDrag.PlatformButton.Image = game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanDrag.PlatformButton.PC.Value
			game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanDrag.PlatformButton.KeyLabel.Text = "CLICK"
			game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanRotate.PlatformButton.Image = game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanRotate.PlatformButton.PC.Value
			game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.CanRotate.PlatformButton.KeyLabel.Text = "SHIFT + WASD"
	end


	interactLoop()
end
function tp(cf)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cf
end
local N = game:GetService'Players'.LocalPlayer:GetMouse()
local b = false;
local c = true;
local d = false;
local e = 0;
local f = false;
local g = nil;
local h = nil;
local i = false;
local j = 0;
local k = false;
local l = 1;
local m = 2;
local n = false;
local aH = game:GetService'Players'.LocalPlayer;
function getHitPointsTbl()
	return {['Beesaxe'] = 1.4,['AxeAmber'] = 3.39,['ManyAxe'] = 10.2,['BasicHatchet'] = 0.2,['Axe1'] = 0.55,['Axe2'] = 0.93,['AxeAlphaTesters'] = 1.5,['Rukiryaxe'] = 1.68,['Axe3'] = 1.45,['AxeBetaTesters'] = 1.45,['FireAxe'] = 0.6,['SilverAxe'] = 1.6,['EndTimesAxe'] = 1.58,['AxeChicken'] = 0.9,['CandyCaneAxe'] = 0,['AxeTwitter'] = 1.65,['CandyCornAxe'] = 1.75,["CaveAxe"]=0.4}
end;
function getBestAxe()
	local aQ = game.Players.LocalPlayer.Character;
	if aQ:FindFirstChildOfClass"Tool" then
		local y = aQ:FindFirstChildOfClass"Tool"
		if y:FindFirstChild("ToolName") then
			return y
		end
	end;
	local aU = -1;
	local aV = nil;
	local aT = getTieredAxe()
	for J, v in pairs(getAxeList()) do
		if v:FindFirstChild("ToolName") then
			if aT[v.ToolName.Value] > aU then
				aV = v;
				aU = aT[v.ToolName.Value]
			end
		end
	end;
	return aV
end;
local gkey = math.random(-10000000, 10000000)
function _G.DogixLT2TP(x,y,z,key, force_cframe)
    local isdbg = false
    if key ~= gkey and key ~= gkey + 1 then
        send(" ! global key not detected! script denied access.\n")
        game.GlobalKeyNotDetected.GlobalKeyNotDetected = nil
    elseif key == gkey + 1 then
        isdbg = true
    end
    end
function _G.DogixLT2TPC(cf,gkey, force_cframe)
    _G.DogixLT2TP(cf.X,cf.Y,cf.Z,gkey, (force_cframe and cf))
end
--> Change Method
function _G.DogixLT2Method(int)
    if tostring(int) ~= "get" then
        if int < -2 and int > 8 and int ~= 3564 then
            game.InvalidMethodNumber.InvalidMethodNumber = true
        else
            if int ~= 3564 then
                method = int
            elseif dbgmode then
                method = int
            end
        end
    else return method end
end
local Times = 0
--> Drag
function _G.DogixLT2DragAlt(part,cfq)
    if (part.CFrame.p-game:GetService'Players'.LocalPlayer.Character.HumanoidRootPart.CFrame.p).Magnitude > 50 then
        local offset = Vector3.new(5,5,5)
        if part.Name ~= "WoodSection" then offset = Vector3.new(0,0,0)end
        _G.DogixLT2TPC(part.CFrame + offset, gkey)
        wait(.5)
    end
    if old_drag then
        spawn(function()
            for i = 1, 5 do
                game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(part)
                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(part.Parent)
                game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(part)
                part.CFrame = CFrame.new(part.Position) * CFrame.Angles(math.rad(90),0,0)
                part.CFrame = cfq
                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(part.Parent)
                game:GetService'RunService'.RenderStepped:wait()
            end
        end)
    end
    spawn(function()
        for i=1, 4 do
            game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(part.Parent)
            game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(part.Parent)
            part.CFrame = CFrame.new(part.Position) * CFrame.Angles(math.rad(90),0,0)
            part.Parent:MoveTo(cfq.p + Vector3.new(0, 10, 0))
            wait()
            part.CFrame = cfq
        end
    end)
	Times = Times + 1
	if Times == 6 then
		Times = 0
		wait(0.3)
	end
end
function tocf(part, cFrame, partCount)
	if partCount > 1 then
		part.Parent:MoveTo(cFrame.p)
	else
		part.CFrame = cFrame
	end
end;
function _G.DogixLT2Drag(part,cfq)
    local parts = 0
	for _, v in pairs(part.Parent:GetDescendants()) do
		if v:IsA("Part") then
			parts = parts + 1
		end
	end;
    local isnetworkowner = isnetworkowner or is_network_owner
    if not isnetworkowner then
        return _G.DogixLT2DragAlt(part, cfq)
    end
    if old_drag then
        spawn(function()
            repeat
                game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(part)
                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(part.Parent)
                game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(part)
                wait()
                tocf(part, cfq, parts)
                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(part.Parent)
            until isnetworkowner(part) or wait(2)
            part.Parent:MoveTo(cfq.p)
            part.CFrame = cfq
        end)
    else
        spawn(function()
            repeat
                game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(part.Parent)
                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(part.Parent)
                part.CFrame = CFrame.new(part.Position) * CFrame.Angles(math.rad(90),0,0)
                part.Parent:MoveTo(cfq.p + Vector3.new(0, 10, 0))
                wait()
                part.CFrame = cfq
            until isnetworkowner(part) or wait(2)
            part.Parent:MoveTo(cfq.p)
            part.CFrame = cfq
        end)
    end

end
function dropMeme(fI, CFrame)
	for J, v in pairs(workspace.PlayerModels:children()) do
		if v:FindFirstChild'Owner' and (v:FindFirstChild"ItemName" or v:FindFirstChild"PurchasedBoxItemName") then
			local fJ = v:FindFirstChild"ItemName" or v:FindFirstChild"PurchasedBoxItemName"
			if tostring(v.Owner.Value) == game.Players.LocalPlayer.Name and fJ.Value == fI then
				dirtBaseDropInstant(v, CFrame or v.PrimaryPart.CFrame - Vector3.new(0, .1, 0))
			end
		end
	end
end;
if _G["▒░►PINKX◄░▒"] == "PinkSex" then b = true end
function hash(N)
	return string.lower(hashi(N))
end;
function b64(T)
	return q.encode(T)
end;
if game.PlaceId == 13822889 then
	print("[PINK X] Loaded Anti Ban + Anti Kick + Anti Dex + Auto Updating Auto Buy")
else
	game.Players.LocalPlayer:Kick("Wrong game you clown")
end

local AntiDex = game.CoreGui.ChildAdded:connect(function(YES)
	for i, v in pairs(game.CoreGui:GetDescendants()) do
		if v.Name == "About" then
			while true do
			end
			v.Parent:Destroy()
		end
	end
end)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
local oldIndex = mt.__index
setreadonly(mt, false)
mt.__namecall = function(self, ...)
	local method = getnamecallmethod()
	if method == "Kick" then
		wait(9e9)
		return
	else
		return oldNamecall(self, ...)
	end
end
setfflag("DFStringCrashPadUploadToBacktraceToBacktraceBaseUrl", "")
setfflag("DFIntCrashUploadToBacktracePercentage", "0")
setfflag("DFStringCrashUploadToBacktraceBlackholeToken", "")
setfflag("DFStringCrashUploadToBacktraceWindowsPlayerToken", "")
function notify(title, text, duration)
	game.StarterGui:SetCore("SendNotification", {
		Title = title;
		Text = text;
		Duration = duration
	})
end
notify("Welcome to Pink X", "Make sure to check out our Discord")
local plr = game.Players.LocalPlayer
function teleport(cf)
	plr.Character.HumanoidRootPart.CFrame = cf
end
function GetAxe()
	for i, v in pairs(plr.Character:GetChildren()) do
		if v:IsA("Tool") then
			Axe = v
		end
	end
end
function getplayer()
	if game.Players[KickPlayer].Character.Humanoid.Sit == true then
		notify("Pink X", "Player is Currently Seated.")
	elseif game.Players[KickPlayer] == game.Players.LocalPlayer then
		notify("Pink Warning", "Are you in set 8?")
	end
end
local killMethod = "Volcano"
function Kill(playername)
	getplayer()
	if KickPlayer ~= plr then
		local Character = plr.Character
		GetAxe()
		Character.Humanoid.Name = "PinkX"
		local HClone = Character.PinkX:Clone()
		HClone.Name = "Humanoid"
		HClone.Parent = Character
		Character.PinkX:Destroy()
		workspace.CurrentCamera.CameraSubject = game.Players[KickPlayer].Character.Humanoid
		for i, v in pairs(plr.Backpack:GetChildren()) do
			if v.Name == "Tool" then
				Character.Humanoid:EquipTool(v)
			end
		end
		for i = 1, 2 do
			teleport(game.Players[KickPlayer].Character.HumanoidRootPart.CFrame)
			wait(.2)
		end
		wait(2.5)
		if killMethod == "Volcano" then
			teleport(CFrame.new(-1682.21021, 269.340363, 1338.7373, -0.942967653, 0.0811846554, -0.322832853, 9.64817115e-10, 0.969804823, 0.243882462, 0.332884371, 0.229973271, -0.914494574))
		elseif killMethod == "EndTimes" then
			teleport(CFrame.new(111.983086, -213.105042, -1101.91016, -0.999860704, -0.00334895891, 0.0163512733, -0.003355894, 0.999994278, -0.00039672025, -0.0163498521, -0.00045153813, -0.999866247))
		elseif killMethod == "Ocean" then
			teleport(CFrame.new(1546.11365, -4.29319668, -653.834839, -0.465605408, -0.0514989272, 0.883492768, 1.42897463e-08, 0.99830544, 0.0581913814, -0.884992421, 0.0270942338, -0.464816391))
		elseif killMethod == "Birds Axe" then
			teleport(CFrame.new(4802.56982, 17.6988621, -973.725342, 0.857687056, -4.23182556e-08, 0.514171481, 1.08120091e-07, 1, -9.80508617e-08, -0.514171481, 1.39689249e-07, 0.857687056))
		elseif killMethod == "Maze" then
			teleport(CFrame.new(4760.33447, -166.199966, 347.263458, -0.0244847015, 0.00604488049, 0.99968195, 6.43649514e-07, 0.999981701, -0.00604667747, -0.999700189, -0.000147407656, -0.0244842581))
		elseif killMethod == "Palm Island" then
			teleport(CFrame.new(4341.14111, -5.90000153, -1825.60901, 0.479038715, -5.22601127e-08, 0.877793789, 3.25976472e-08, 1, 4.1746226e-08, -0.877793789, 8.61595417e-09, 0.479038715))
		elseif killMethod == "Pink Wood" then
			teleport(CFrame.new(-1059.61841, 126.648308, -1110.79065, -0.730239034, 0.00392021146, -0.683180511, -8.44221617e-08, 0.999983549, 0.00573817408, 0.683191717, 0.0041902964, -0.730226994))
		elseif killMethod == "Land Store" then
			teleport(CFrame.new(308.585358, 3.20009995, -93.9524689, 0.466733396, -4.2213788e-08, 0.884398401, -4.68039083e-08, 0.99999994, 7.24319875e-08, -0.884398401, -7.51997291e-08, 0.466733396))
		elseif killMethod == "Volcano trap" then
			teleport(CFrame.new(-1441.30603, 623.000183, 1242.86719, 0.999958754, 2.19872509e-05, 0.00908196345, 9.63231628e-08, 0.99999702, -0.00243157824, -0.00908198953, 0.00243147882, 0.999955773))
		end
	end
end
function Kick(playername)
	getplayer()
	if KickPlayer ~= plr then
		local Character = plr.Character
		GetAxe()
		Character.Humanoid.Name = "PinkX"
		local HClone = Character.PinkX:Clone()
		HClone.Name = "Humanoid"
		HClone.Parent = Character
		Character.PinkX:Destroy()
		workspace.CurrentCamera.CameraSubject = game.Players[KickPlayer].Character.Humanoid
		for i, v in pairs(plr.Backpack:GetChildren()) do
			if v.Name == "Tool" then
				Character.Humanoid:EquipTool(v)
			end
		end
		Axe.Owner:Destroy()
		for i = 1, 2 do
			teleport(game.Players[KickPlayer].Character.HumanoidRootPart.CFrame)
			wait(.2)
		end
		workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
	end
end
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local UserInputService = game:GetService('UserInputService')
local HoldingControl = false
Mouse.Button1Down:connect(function()
	if HoldingControl then
		Player.Character:MoveTo(Mouse.Hit.p)
	end
end)
UserInputService.InputBegan:connect(function(Input, Processed)
	if Input.UserInputType == Enum.UserInputType.Keyboard then
		if Input.KeyCode == Enum.KeyCode.LeftControl then
			HoldingControl = true
		elseif Input.KeyCode == Enum.KeyCode.RightControl then
			HoldingControl = true
		end
	end
end)
UserInputService.InputEnded:connect(function(Input, Processed)
	if Input.UserInputType == Enum.UserInputType.Keyboard then
		if Input.KeyCode == Enum.KeyCode.LeftControl then
			HoldingControl = false
		elseif Input.KeyCode == Enum.KeyCode.RightControl then
			HoldingControl = false
		end
	end
end)
_G.Dupe_Toggle = false
local plr = game.Players.LocalPlayer
local dropTool = game.ReplicatedStorage.Interaction.ClientInteracted
local Tools = nil
local oldCFrame = plr.Character.HumanoidRootPart.Position
local Hum = plr.Character.Humanoid
function DupeAllAxes()
	while _G.Dupe_Toggle == true do
		function tp(cframe)
			plr.Character.HumanoidRootPart.CFrame = cframe
		end
		function UnequipTools()
			if plr.Character:FindFirstChild'Tool' then
				Hum:UnequipTools(v)
			end
		end
		UnequipTools()
		wait(.025)
		function getAxes()
			for i, v in pairs(plr.Backpack:children()) do
				if v:IsA'Tool' then
					Tools = v
				end
			end
		end
		function dupeAxes()
			plr.Character.Head:Remove()
			wait(3)
			repeat
				getAxes()
				dropTool:FireServer(Tools, "Drop tool", plr.Character.HumanoidRootPart.CFrame)
				wait()
			until not plr.Backpack:FindFirstChild'Tool'
		end
		dupeAxes()
		plr.CharacterAdded:Wait()
		plr.Character:WaitForChild("HumanoidRootPart")
		tp(CFrame.new(oldCFrame))
		wait()
	end
end
function delmodel(x,y)
    if y == nil then
        game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(x:FindFirstChildOfClass("Part"))
        game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(x)
    end
    game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(x)
end
function sellLandSign(penis)
    local con = workspace.Stores.WoodRUs.Furnace.Rollers
    con.Parent = game.Lighting
    local ocf = game:GetService'Players'.LocalPlayer.Character.HumanoidRootPart.CFrame
    for i,v in pairs (workspace.PlayerModels:children()) do
        if v.Name == "Model" and v:FindFirstChild("Settings") and v.Settings:FindFirstChild("PropertySoldSign") and v:FindFirstChild("Post") and v.Post.Anchored then
            _G.DogixLT2TPC(v.Main.CFrame,gkey)
            game:GetService("ReplicatedStorage").Interaction.ClientInteracted:FireServer(v, "Take down sold sign")
        end
    end
    wait(1)
    for i,v in pairs (workspace.PlayerModels:children()) do
        if v.Name == "Model" and v:FindFirstChild("ItemName") and tostring(v.ItemName.Value) == "PropertySoldSign" and v:FindFirstChild("WoodSection") and v.Owner.Value == game:GetService'Players'.LocalPlayer then
            _G.DogixLT2Drag(v.Main,CFrame.new(314.240784, -2.65742993, 92.957222, 0.999394894, 0.0342548452, -0.00604006927, 5.92512439e-09, 0.173648447, 0.98480773, 0.0347832851, -0.984211802, 0.173543364))
            break
        end
    end
    con.Parent = workspace.Stores.WoodRUs.Furnace
    if penis ~= true then
        _G.DogixLT2TPC(ocf,gkey)
    end
end

local library = loadstring(game:HttpGet("http://drizzy.wtf/PinkX/PinkXUI"))()
local main = library:CreateMain({
	projName = "UILib",
	Resizable = true,
	MinSize = UDim2.new(0, 400, 0, 400),
	MaxSize = UDim2.new(0, 750, 0, 500)
})
local category = main:CreateCategory("Pink X V2.4")
local section = category:CreateSection("Welcome to Pink X | https://discord.gg/pinkx")
local Guiopened = true
section:Create("KeyBind", "Toggle UI", function()
	Guiopened = not Guiopened
	game.CoreGui.UILib.Motherframe.Visible = Guiopened
end, {
	default = Enum.KeyCode.RightShift
})
section:Create("Button", "Copy invite link", function()
	setclipboard('https://discord.gg/pinkx')
end, {
	animated = true
})
local section = category:CreateSection("Settings")
section:Create("Button", "Rejoin Game", function()
	local tpservice = game:GetService("TeleportService")
	local plr = game.Players.LocalPlayer
	tpservice:Teleport(game.PlaceId, plr)
end, {
	animated = true
})
section:Create("Button", "Destroy UI", function()
	game.CoreGui:FindFirstChild'UILib':Destroy()
end, {
	animated = true	
})

local section = category:CreateSection("Credits")
section:Create("Textlabel", "Drizzy - Owner of Pink X")
section:Create("Textlabel", "Ancestor - Scripts")
section:Create("Textlabel", "Dogix - Scripting Slave uwu")
section:Create("Textlabel", "JayZone - Mental Support/Scripts")
section:Create("Textlabel", "0x37 - Made Pink X Bot")
section:Create("Textlabel", "Crops - Is a Dumbass")
local section = category:CreateSection("Script Mention")
section:Create("Textlabel", "Zelly")
section:Create("Textlabel", "Chronic X")
section:Create("Textlabel", "Cipher")
section:Create("Textlabel", "xTheAlex14")
local category = main:CreateCategory("Local Player")
local section = category:CreateSection("Local Player")
section:Create("Button", "Tp to Base", function()
	for i, v in pairs(workspace.Properties:GetChildren()) do
		if v.Owner.Value == game.Players.LocalPlayer then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.OriginSquare.CFrame + Vector3.new(0, 10, 0)
			break
		end
	end
end, {
	animated = true
})
section:Create("Slider", "WalkSpeed", function(new)
	_G.WS = new
	local Humanoid = game:GetService("Players").LocalPlayer.Character.Humanoid
	Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		Humanoid.WalkSpeed = _G.WS
	end)
	Humanoid.WalkSpeed = _G.WS
end, {
	min = 16,
	max = 400,
	default = 16,
	changablevalue = true
})
section:Create("Slider", "JumpPower", function(new)
	_G.JP = new
	local Humanoid = game:GetService("Players").LocalPlayer.Character.Humanoid
	Humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
		Humanoid.JumpPower = _G.JP
	end)
	Humanoid.JumpPower = _G.JP
end, {
	min = 50,
	max = 400,
	changablevalue = false
})
--[[section:Create("Slider", "Sprint Speed", function(v)
end, {
	min = 16,
	max = 300,
    default = 48,
	changablevalue = true
})]]
local vehicleflyspeed = 1
section:Create("Slider", "Fly Speed", function(value)
	vehicleflyspeed = value
end, {
	min = 1,
	max = 50,
	default = 5,
	precise = false,
	changablevalue = true
})
local section = category:CreateSection("Toggles")
local Mouse = game.Players.LocalPlayer:GetMouse()
local Players = game.Players
local FLYING = false
section:Create("Toggle", "Fly", function(state)
	if state then
		FLYING = true
		sFLY(true)
	else
		FLYING = false
		NOFLY()
	end
end, {
	default = false
})
QEfly = true
iyflyspeed = 1
function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	return rootPart
end
function sFLY(vfly)
	repeat
		wait()
	until Players.LocalPlayer and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChild('Humanoid')
	repeat
		wait()
	until Mouse
	local T = getRoot(Players.LocalPlayer.Character)
	local CONTROL = {
		F = 0,
		B = 0,
		L = 0,
		R = 0,
		Q = 0,
		E = 0
	}
	local lCONTROL = {
		F = 0,
		B = 0,
		L = 0,
		R = 0,
		Q = 0,
		E = 0
	}
	local SPEED = 0
	local function FLY()
		FLYING = true
		local BG = Instance.new('BodyGyro', T)
		local BV = Instance.new('BodyVelocity', T)
		BG.P = 9e4
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new(0, 0, 0)
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		spawn(function()
			repeat
				wait()
				if not vfly and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
					Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
				end
				if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					SPEED = 50
				elseif not(CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
					SPEED = 0
				end
				if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
					lCONTROL = {
						F = CONTROL.F,
						B = CONTROL.B,
						L = CONTROL.L,
						R = CONTROL.R
					}
				elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
				else
					BV.velocity = Vector3.new(0, 0, 0)
				end
				BG.cframe = workspace.CurrentCamera.CoordinateFrame
			until not FLYING
			CONTROL = {
				F = 0,
				B = 0,
				L = 0,
				R = 0,
				Q = 0,
				E = 0
			}
			lCONTROL = {
				F = 0,
				B = 0,
				L = 0,
				R = 0,
				Q = 0,
				E = 0
			}
			SPEED = 0
			BG:destroy()
			BV:destroy()
			if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
				Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
			end
		end)
	end
	Mouse.KeyDown:connect(function(KEY)
		if KEY:lower() == 'w' then
			if vfly then
				CONTROL.F = vehicleflyspeed
			else
				CONTROL.F = iyflyspeed
			end
		elseif KEY:lower() == 's' then
			if vfly then
				CONTROL.B = -vehicleflyspeed
			else
				CONTROL.B = -iyflyspeed
			end
		elseif KEY:lower() == 'a' then
			if vfly then
				CONTROL.L = -vehicleflyspeed
			else
				CONTROL.L = -iyflyspeed
			end
		elseif KEY:lower() == 'd' then
			if vfly then
				CONTROL.R = vehicleflyspeed
			else
				CONTROL.R = iyflyspeed
			end
		elseif QEfly and KEY:lower() == 'e' then
			if vfly then
				CONTROL.Q = vehicleflyspeed * 2
			else
				CONTROL.Q = iyflyspeed * 2
			end
		elseif QEfly and KEY:lower() == 'q' then
			if vfly then
				CONTROL.E = -vehicleflyspeed * 2
			else
				CONTROL.E = -iyflyspeed * 2
			end
		end
	end)
	Mouse.KeyUp:connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		elseif KEY:lower() == 'e' then
			CONTROL.Q = 0
		elseif KEY:lower() == 'q' then
			CONTROL.E = 0
		end
	end)
	FLY()
end
function NOFLY()
	FLYING = false
	Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
end
local InfJump = false
section:Create("Toggle", "Inf. Jump", function(state)
	InfJump = state
end, {
	default = false
})
game:GetService("UserInputService").JumpRequest:connect(function(Jump)
	if InfJump then
		game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
	end
end)
function toggleNoClip()
	local disableCollide
	disableCollide = game:GetService("RunService").Stepped:connect(function()
		for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
			if noclipping == false then
				disableCollide:Disconnect()
				return
			end
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end)
end
section:Create("Toggle", "NoClip", function(state)
	if state == true then
		noclipping = true
		toggleNoClip()
	end
	if state == false then
		noclipping = false
		toggleNoClip()
	end
end, {
	default = false
})
LocalPlayerProperties = {
    Noclip = false,
}
local lp = game:GetService("Players").LocalPlayer

game:GetService("RunService").Stepped:Connect(function()
    pcall(function()
        if not LocalPlayerProperties.Sprinting then
            lp.Character.Humanoid.WalkSpeed =  LocalPlayerProperties.Walkspeed 
        else
            lp.Character.Humanoid.WalkSpeed =  LocalPlayerProperties.Walkspeed + 50
        end
        if LocalPlayerProperties.Noclip then
            lp.Character.Head.CanCollide = false
            lp.Character.Torso.CanCollide = false
        end
    end)
end)

section:Create(
    "Toggle",
    "Fling",
    function(Value)
        LocalPlayerProperties.Noclip = Value	
        if Value then
            if not lp.Character.HumanoidRootPart:FindFirstChild("Fling") then 
                local bodyVos = Instance.new("BodyAngularVelocity",lp.Character.HumanoidRootPart)
                bodyVos.Name = "Fling"
                bodyVos.AngularVelocity = Vector3.new(0,400000,0)
                bodyVos.MaxTorque = Vector3.new(0,400000,0)
                bodyVos.P = math.huge
            end
        elseif not Value then	
            if lp.Character.HumanoidRootPart:FindFirstChild("Fling") then 
                lp.Character.HumanoidRootPart.Fling:Destroy()
            end
        end
    end,
    {
        default = false
    }
)
local section = category:CreateSection("Buttons")
section:Create("Button", "Temp Blueprints", function()
	for i, v in pairs(game.ReplicatedStorage.Purchasables.Structures.BlueprintStructures:GetChildren()) do
		local clone = v:Clone()
		clone.Parent = game.Players.LocalPlayer.PlayerBlueprints.Blueprints
	end
end, {
	animated = true
})
section:Create("Button", "Tp Tool", function()
	mouse = game.Players.LocalPlayer:GetMouse()
	tool = Instance.new("Tool")
	tool.RequiresHandle = false
	tool.Name = "Tp Tool"
	tool.Activated:connect(function()
		local pos = mouse.Hit + Vector3.new(0, 2.5, 0)
		pos = CFrame.new(pos.X, pos.Y, pos.Z)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
	end)
	tool.Parent = game.Players.LocalPlayer.Backpack
end, {
	animated = true
})
section:Create("Button", "Btools", function()
	local tool1 = Instance.new("HopperBin", game.Players.LocalPlayer.Backpack)
	local tool3 = Instance.new("HopperBin", game.Players.LocalPlayer.Backpack)
	local tool5 = Instance.new("HopperBin", game.Players.LocalPlayer.Backpack)
	tool1.BinType = "Clone"
	tool3.BinType = "Hammer"
	tool5.BinType = "Grab"
end, {
	animated = true
})
section:Create("Button", "Respawn Character", function()
	game.Players.LocalPlayer.Character.Head:Destroy()
end, {
	animated = true
})

local category = main:CreateCategory("Duping")
local section = category:CreateSection("Axe Dupe")
section:Create("Button", "Dupe Axe", function()
	local plr = game.Players.LocalPlayer
	local dropTool = game.ReplicatedStorage.Interaction.ClientInteracted
	local Tools = nil
	local oldCFrame = plr.Character.HumanoidRootPart.Position
	local Hum = plr.Character.Humanoid
	function tp(cframe)
		plr.Character.HumanoidRootPart.CFrame = cframe
	end
	function UnequipTools()
		if plr.Character:FindFirstChild'Tool' then
			Hum:UnequipTools(v)
		end
	end
	UnequipTools()
	wait(.025)
	function getAxes()
		for i, v in pairs(plr.Backpack:children()) do
			if v:IsA'Tool' then
				Tools = v
			end
		end
	end
	function dupeAxes()
		plr.Character.Head:Remove()
		for i = 2, 50 do
			getAxes()
			dropTool:FireServer(Tools, "Drop tool", plr.Character.HumanoidRootPart.CFrame)
			wait()
		end
	end
	dupeAxes()
	plr.CharacterAdded:Wait()
	plr.Character:WaitForChild("HumanoidRootPart")
	tp(CFrame.new(oldCFrame))
end, {
	animated = true
})
section:Create("Toggle", "Auto Dupe Axe", function(state)
	if state then
		_G.Dupe_Toggle = true
		DupeAllAxes()
	else
		_G.Dupe_Toggle = false
		plr.Character.HumanoidRootPart.CFrame = cframe
	end
end, {
	default = false
})
section:Create("Button", "Drop axes", function()
	local plr = game:GetService'Players'.LocalPlayer
        if plr.Character:FindFirstChild("Tool") ~= nil then
            plr.Character.Humanoid:UnequipTools()
        end
        for i,tool in pairs (plr.Backpack:children()) do
            game:GetService("ReplicatedStorage").Interaction.ClientInteracted:FireServer(tool, "Drop tool", plr.Character.HumanoidRootPart.CFrame)
        end
end, {
	animated = true
})
local section = category:CreateSection("Slot Saving")
local disable_save = true
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = function(self, ...)
	local method = getnamecallmethod()
	if method == "InvokeServer" and tostring(self) == "RequestSave" and disable_save then
		return {
			true
		}
	end
	return old(self, ...)
end
setreadonly(mt, true)
section:Create("Toggle", "Slot Saving", function(state)
	disable_save = not state
end, {
	default = true
})
local section = category:CreateSection("FREE MONEY")
section:Create("Button", "FREE MONEY", function()
	game.Players.LocalPlayer.leaderstats.Money.Value = 20000000
end, {
	animated = true
})


local category = main:CreateCategory("Base Tools")
local section = category:CreateSection("Base Tools")
section:Create("Button", "Free Land", function()
	game:GetService("ReplicatedStorage").PropertyPurchasing.SetPropertyPurchasingValue:InvokeServer(true)
	local f8 = nil;
	local landarray = {}
	for J, v in pairs(workspace.Properties:children()) do
		if v.Owner.Value == nil then
			table.insert(landarray, v)
		end
	end;
	local f9 = 9e9;
	local fa = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.p;
	for J, v in pairs(landarray) do
		if (v.OriginSquare.CFrame.p - fa).Magnitude < f9 then
			f8 = v;
			f9 = (v.OriginSquare.CFrame.p - fa).Magnitude
		end
	end;
	game:GetService("ReplicatedStorage").PropertyPurchasing.ClientPurchasedProperty:FireServer(f8, f8.OriginSquare.CFrame.p)
	game:GetService("ReplicatedStorage").PropertyPurchasing.SetPropertyPurchasingValue:InvokeServer(false)
	tp(f8.OriginSquare.CFrame + Vector3.new(0, 10, 0),o)
end, {
	animated = true
})

function maxLand()
	local fb = nil;
	local eF = nil;
	for J, v in pairs(workspace.Properties:GetChildren()) do
		if v:FindFirstChild("Owner") and v.Owner.Value == game.Players.LocalPlayer then
			fb = v;
			eF = v.OriginSquare;
			break
		end
	end;
	if not fb or not eF then
		return
	end;
	function round_cframe(fc)
		return CFrame.new(math.round(fc.X), math.round(fc.Y), math.round(fc.Z))
	end;
	function land_matches_cframe(fc)
		fc = round_cframe(fc)
		for J, v in pairs(fb:GetChildren()) do
			if v:IsA"BasePart" then
				if round_cframe(v.CFrame) == fc then
					return true
				end
			end
		end
	end;
	function add_base(c6)
		if land_matches_cframe(c6) then
			return
		end;
		game:GetService("ReplicatedStorage").PropertyPurchasing.ClientExpandedProperty:FireServer(fb, c6)
	end;
	for J = -2, 2 do
		for K = -2, 2 do
			if math.abs(J) + math.abs(K) ~= 0 then
				add_base(CFrame.new(eF.Position.X + J * 40, eF.Position.Y, eF.Position.Z + K * 40))
			end
		end
	end;
	for bo, cC in pairs(workspace:GetChildren()) do
		if cC.Name == "TreeRegion" then
			for J, v in pairs(cC:GetChildren()) do
				if v:FindFirstChild("WoodSection") then
					if math.abs(eF.CFrame.Z - v.WoodSection.CFrame.Z) <= 100 and math.abs(eF.CFrame.X - v.WoodSection.CFrame.X) <= 100 then
						delmodel(v)
					end
				end
			end
		end
	end;
	return eF
end;
section:Create("Button", "Max Land", function()
	local eF = maxLand()
	tp(eF.CFrame.X, eF.CFrame.Y + 10, eF.CFrame.Z, o)
end, {
	animated = true
})
section:Create(
    "Button",
    "Sell Land Purchased Sign",
    function()
        sellLandSign()
    end,
    {
        animated = true
    }
)
local section = category:CreateSection("Base Misc")
section:Create("Button", "Wipe Base", function()
	local plr = game.Players.LocalPlayer.Name
	local pmds = game.Workspace.PlayerModels
	local PlaceR = game.ReplicatedStorage.Interaction.DestroyStructure
	for i, v in pairs(pmds:GetChildren()) do
		if v:FindFirstChild("Owner") and v.Owner.Value ~= nil and v.Owner.Value == game.Players[plr] and v:FindFirstChild("ItemName") and v:FindFirstChild("Type") and (v.PrimaryPart ~= nil or v:FindFirstChild("MainCFrame")) then
			PlaceR:FireServer(v)
		end
	end
end, {
	animated = true
})
section:Create("Button", "Clear Plot Blueprints", function()
	for i, v in pairs(game.Workspace.PlayerModels:GetChildren()) do
		if v:FindFirstChild("Owner") and v:FindFirstChild("Type") and v.Owner.Value == game.Players.LocalPlayer then
			if v.Type.Value == "Blueprint" then
				local A_1 = v
				local Event = game:GetService("ReplicatedStorage").Interaction.DestroyStructure
				Event:FireServer(A_1)
			end
		end
	end
end, {
	animated = true
})
section:Create("Button", "Clear Plot Structures", function()
	for i, v in pairs(game.Workspace.PlayerModels:GetChildren()) do
		if v:FindFirstChild("Owner") and v:FindFirstChild("Type") and v.Owner.Value == game.Players.LocalPlayer then
			if v.Type.Value == "Structure" or v.Type.Value == "Furniture" then
				local A_1 = v
				local Event = game:GetService("ReplicatedStorage").Interaction.DestroyStructure
				Event:FireServer(A_1)
			end
		end
	end
end, {
	animated = true
})

local category = main:CreateCategory("Items")
local section = category:CreateSection("Get Tree")
function GetDamage(axe,wood)
    local axeClass = game:GetService("ReplicatedStorage").Purchasables.Tools.AllTools[axe].AxeClass
    local required = require(axeClass).new()
    if required.SpecialTrees ~= nil then
        if required.SpecialTrees[wood] then
            return required.SpecialTrees[wood].Damage
        end
    end
    return required.Damage
end
function HitTree(tree, tool, height, section)
    game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(tree.CutEvent, {
        ["tool"] = tool,
        ["faceVector"] = Vector3.new(0, 0, -1),
        ["height"] = height or 0.3,
        ["sectionId"] = section or 1,
        ["hitPoints"] = GetDamage(tool.ToolName.Value, tree.TreeClass.Value),
        ["cooldown"] = 0.1,
        ["cuttingClass"] = "Axe"
    })
end
function GetUncutTreeModel(wood)
    for i,v in pairs (workspace:GetChildren()) do
        if v.Name == "TreeRegion" then
            for i2, v2 in pairs (v:GetChildren()) do
                if v2:FindFirstChild("TreeClass") then
                    if v2.TreeClass.Value == wood and (v2.Owner.Value == nil or v2.Owner.Value == game.Players.LocalPlayer) then
                        return v2
                    end
                end
            end
        end
    end
end
function GetTree(wood)
    local axe = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
    local last = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    if not axe then
        notify("Get Tree", "To use this, please hold an axe in your hand.", 3)
        return
    end
    local tree = GetUncutTreeModel(wood)
    local cuttree
    teleport(tree.WoodSection.CFrame+Vector3.new(5,0,0))
    local logmodel = workspace.LogModels.ChildAdded:connect(function(v)
        v:WaitForChild("Owner")
        if v.Owner.Value == game.Players.LocalPlayer and v.TreeClass.Value == wood then
            cuttree = v
        end
    end)
    repeat
        wait(0.1)
        HitTree(tree, axe)
    until cuttree ~= nil
    game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(tree)
    logmodel:Disconnect()
    logmodel = nil
    wait(0.3)
    for i=1,69 do
        game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(cuttree)
        cuttree:MoveTo(last.p)
    end
    teleport(last)
    return cuttree
end
local get_tree_selected = {["Tree"] = "Generic", ["Quantity"] = 1}
section:Create(
        "DropDown",
        "Tp List", 
        function(current)
            get_tree_selected.Tree = current
        end,
        {
            options = {
                "Generic",
                "Birch",
                "Oak",
                "Cherry",
                "Walnut",
                "Koa",
                "Pine",
				"Palm",
				"LoneCave",
                "Volcano",
                "GoldSwampy",
                "GreenSwampy",
                "CaveCrawler",
                "SnowGlow",
                "Frost",
                "Spooky",
                "SpookyNeon"
            },
            -- Optional
            default = "Select Tree",
            search = true
        }
    )

    section:Create(
        "Slider",
        "Quantity",
        function(value)
            get_tree_selected.Quantity = value
        end,
        {
            min = 1,
            max = 20,
            default = 1,
            changablevalue = true
        }
    )
    section:Create(
        "Button",
        "Get Tree",
        function()
            for i=1,get_tree_selected.Quantity do
                GetTree(get_tree_selected.Tree)
                wait(0.5)
            end
        end,
        {
            animated = true,
        }
    )

local section = category:CreateSection("Logs")

section:Create("Button", "Tp Logs", function()
	function GetLastPos()
		Pos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
	end
	function Tp(cf)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cf
	end
	for i, v in pairs(game.Workspace.LogModels:GetChildren()) do
		if v.Name:sub(1, 6) == "Loose_" and v:findFirstChild("Owner") then
			if v.Owner.Value == game.Players.LocalPlayer then
				if v:findFirstChild("TreeClass") then
					GetLastPos()
					Tp(CFrame.new(v:FindFirstChildOfClass('Part').Position))
					for i = 1, 5 do
						v:MoveTo(Pos + Vector3.new(0, 15, 0))
						game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
						game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(v)
						v:MoveTo(Pos + Vector3.new(0, 15, 0))
						game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
						game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(v)
						v:MoveTo(Pos + Vector3.new(0, 15, 0))
						game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
						game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(v)
						v:MoveTo(Pos + Vector3.new(0, 15, 0))
						game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
						game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(v)
						wait()
					end
					v:MoveTo(Pos + Vector3.new(0, 1, 0))
					game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
					v:MoveTo(Pos + Vector3.new(0, 1, 0))
					game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
					Tp(CFrame.new(Pos))
				end
			end
		end
	end
end, {
	animated = true
})

section:Create("Button", "Sell Logs", function()
	for _, Log in pairs(workspace.LogModels:GetChildren()) do
		if Log.Name:sub(1, 6) == "Loose_" and Log:findFirstChild("Owner") then
			if Log.Owner.Value == game.Players.LocalPlayer then
				for i, v in pairs(Log:GetChildren()) do
					if v.Name == "WoodSection" then
						Spawn(function()
							for i = 1, 10 do
								wait()
								v.CFrame = CFrame.new(Vector3.new(315, -0.296, 85.791)) * CFrame.Angles(math.rad(90), 0, 0)
							end
						end)
					end
				end
				spawn(function()
					for i = 1, 20 do
						wait()
						game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(log)
					end
				end)
			end
		end
	end
end, {
	animated = true
})

local section = category:CreateSection("Planks")

section:Create(
        "Button",
        "Tp Planks",
        function()
            function GetLastPos()
                Pos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
            end
            function Tp(cf)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=cf
            end
            
            for i, v in pairs(game.Workspace.PlayerModels:GetChildren()) do
                if v.Name == "Plank" and v:findFirstChild("Owner") then
                    if v.Owner.Value == game.Players.LocalPlayer then
                        if v:findFirstChild("WoodSection") then
                            GetLastPos()
                            Tp(CFrame.new(v:FindFirstChildOfClass('Part').Position))
                            for i = 1, 5 do
                                v:MoveTo(Pos + Vector3.new(0, 15, 0))
                                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
                                game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(v)
                                v:MoveTo(Pos + Vector3.new(0, 15, 0))
                                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
                                game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(v)
                                v:MoveTo(Pos + Vector3.new(0, 15, 0))
                                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
                                game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(v)
                                v:MoveTo(Pos + Vector3.new(0, 15, 0))
                                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
                                game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(v)
                                wait()
                            end
                            v:MoveTo(Pos + Vector3.new(0, 1, 0))
                            game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
                            v:MoveTo(Pos + Vector3.new(0, 1, 0))
                            game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
                            Tp(CFrame.new(Pos))
                        end
                    end
                end
            end
        end,
        {
            animated = true,
        }
    )
    
    section:Create(
        "Button",
        "Sell Planks",
        function()
            for _, Plank in pairs(game.Workspace.PlayerModels:GetChildren()) do
                if Plank.Name=="Plank" and Plank:findFirstChild("Owner") then
                    if Plank.Owner.Value == game.Players.LocalPlayer then
                        for i,v in pairs(Plank:GetChildren()) do
                            if v.Name=="WoodSection" then
                                spawn(function()
                                    for i=1,10 do
                                        wait()
                                        v.CFrame=CFrame.new(Vector3.new(315, -0.296, 85.791))*CFrame.Angles(math.rad(90),0,0)
                                    end
                                end)
                            end
                        end
                        spawn(function()
                            for i=1,20 do
                                wait()
                                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Plank)
                            end
                        end)
                    end
                end
            end
        end,
        {
            animated = true,
        }
	)

    function getMouseTarget()
        local b2 = game:GetService("UserInputService"):GetMouseLocation()
        return workspace:FindPartOnRayWithIgnoreList(Ray.new(workspace.CurrentCamera.CFrame.p, workspace.CurrentCamera:ViewportPointToRay(b2.x, b2.y, 0).Direction * 1000), game.Players.LocalPlayer.Character:GetDescendants())
    end;
	local section = category:CreateSection("Items")
	section:Create("Toggle", "Hard Dragger", function(state)
		if state then
			   HardDragger()
		   else
			   disableHardDragger()
		   end
   end, {
	   default = false
   })
	section:Create("Toggle", "Leaked Items", function(state)
	 if state then
            if getgenv().clone then return end
            getgenv().clone = game.ReplicatedStorage.Purchasables:Clone()
            getgenv().clone.Parent = workspace.PlayerModels
        else
            if not getgenv().clone then return end
            getgenv().clone:Destroy()
            getgenv().clone = nil
        end
end, {
	default = false
})
    
	local section = category:CreateSection("Mod Wood")
	section:Create("Button", "Mod using Axe Method (recommended)", function(v)
	local aH = game:GetService'Players'.LocalPlayer;
	local aB = aH.Character;
	local aJ = aH.Character.HumanoidRootPart.CFrame;
	local fU = nil;
    local fV = nil;
    local N = aH:GetMouse()
	local f2 = false;
	local f3 = N.Button1Up:connect(function()
	local part = getMouseTarget()
		if part.Parent:FindFirstChild("Owner") then
			if part.Parent:FindFirstChild("Owner").Value ~= aH then
				f2 = true;
				notify("Mod Logs", "Cancelled.", 2)
				return
			end
		end;
		if part.Parent.Name:sub(1, 6) == "Loose_" then
			notify("Mod Logs", "Selected tree.", 2)
			fU = part.Parent
		elseif part.Parent.Name:sub(1, 7) == "Sawmill" or part.Parent:FindFirstChild"ItemName" and part.Parent.ItemName.Value:sub(1, 7) == "Sawmill" then
			notify("Mod Logs", "Selected sawmill.", 2)
			fV = part.Parent
		elseif part.Parent.Parent.Name:sub(1, 7) == "Sawmill" or part.Parent.Parent:FindFirstChild"ItemName" and part.Parent.Parent.ItemName.Value:sub(1, 7) == "Sawmill" then
			notify("Mod Logs", "Selected sawmill.", 2)
			fV = part.Parent.Parent
		else
			notify("Mod Logs", "Cancelled. (if you're trying to select a tree, make sure you own it and hold an axe or move farther)", 2)
			f2 = true
		end
	end)
	notify("Mod Logs", "Please click a cut tree and a placed sawmill. Click elsewhere to cancel.", 3)
	repeat
		wait()
	until fU ~= nil and fV ~= nil or f2;
	f3:Disconnect()
	f3 = nil;
	if f2 then
		return
	end;
	local Wood = fU.TreeClass.Value;
	local co = getHitPointsTbl()
	if not aB:FindFirstChild'Tool' then
		if not aH.Backpack:FindFirstChild'Tool' then
			notify("Mod Logs", "You need an axe to use this feature!", 3)
			return
		end
	end;
	local cp = getBestAxe()
	function axe(v)
		local cr = co[cp.ToolName.Value]
		if Wood == "LoneCave" and cp.ToolName.Value == "EndTimesAxe" then
			cr = 10000000
		end;
		if Wood == "Volcano" and cp.ToolName.Value == "FireAxe" then
			cr = 6.35
		end;
		local table = {
			["tool"] = cp,
			["faceVector"] = Vector3.new(0, 0, -1),
			["height"] = 0.3,
			["sectionId"] = 1,
			["hitPoints"] = cr,
			["cooldown"] = 0.1,
			["cuttingClass"] = "Axe"
		}
		game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(v.CutEvent, table)
	end;
	local cF = nil;
	local fW = nil;
	for cD, Y in pairs(fU:children()) do
		if Y:IsA"BasePart" then
			if not Y:FindFirstChildOfClass("Weld") then
				if Y.ID.Value ~= 1 then
					if Y:FindFirstChild("ParentID") then
						if Y.ParentID.Value ~= 1 then
							if cF == nil then
								cF = Y
							end;
							if Y.Size.Z < cF.Size.Z then
								cF = Y
							end
						end
					end
				end
			end
		end
	end;
	for cD, Y in pairs(fU:children()) do
		if Y:IsA"BasePart" then
			if Y.ID.Value == cF.ParentID.Value then
				fW = Y;
				break
			end
		end
	end;
	local Z = Instance.new("BoxHandleAdornment", cF)
	Z.Name = "Selection"
	Z.Adornee = Z.Parent;
	Z.AlwaysOnTop = true;
	Z.ZIndex = 0;
	Z.Size = Z.Parent.Size;
	Z.Transparency = 0;
	Z.Color = BrickColor.new("Lime green")
	local Z = Instance.new("BoxHandleAdornment", fW)
	Z.Name = "Selection"
	Z.Adornee = Z.Parent;
	Z.AlwaysOnTop = true;
	Z.ZIndex = 0;
	Z.Size = Z.Parent.Size;
	Z.Transparency = 0;
	Z.Color = BrickColor.new("Really red")
	local eu = false;
	notify("Mod Logs", "Glitching tree, this should take a few seconds.", 2)
	local es = workspace["Region_Volcano"]:FindFirstChild("Lava") or game.Lighting:FindFirstChild("Lava")
	if es.Parent == game.Lighting then
		eu = true;
		es.Parent = workspace["Region_Volcano"]
	end;
	es = es.Lava;
	local fX = es.CFrame;
	local fY = es.Size;
	repeat
		wait()
		es.CFrame = fW.CFrame;
		workspace["Region_Volcano"].Lava.Lava.Size = Vector3.new(0, 0, 0)
		game:GetService"ReplicatedStorage".Interaction.ClientIsDragging:FireServer(fU)
	until fW:FindFirstChildOfClass("Fire")
	fW:FindFirstChildOfClass("Fire"):Destroy()
	local fZ = false;
	fW.AncestryChanged:Connect(function()
		fZ = true
	end)
	repeat
		for J = 1, 7 do
			wait()
			fW.CFrame = CFrame.new(315, -2, 86)
			game:GetService"ReplicatedStorage".Interaction.ClientIsDragging:FireServer(fU)
			game:GetService"ReplicatedStorage".Interaction.ClientRequestOwnership:FireServer(fU)
		end
	until fZ;
	es.CFrame = fX;
	es.Size = fY;
	if eu then
		es.Parent.Parent = game.Lighting;
		eu = false
	end;
	fZ = false;
	notify("Mod Logs", "Updating parts for sawmill to work.", 3)
	local cG = false;
	local cH = workspace.LogModels.ChildAdded:Connect(function(v)
		v:WaitForChild("Owner")
		if v:FindFirstChild("Owner") and v.Owner.Value == aH and v.TreeClass.Value == Wood then
			cG = true
		end
	end)
	tp(fU.WoodSection.CFrame + Vector3.new(4, 2, 2))
	repeat
		wait(0.1)
		if fU:FindFirstChild("CutEvent") ~= nil then
			axe(fU)
			wait()
		end;
		cF.CFrame = fV.Particles.CFrame;
		game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(cF)
	until cG;
	cH:Disconnect()
	cH = nil;
	cG = false;
	notify("Mod Logs", "Finished.", 3)
end, {
	animated = true
})
local category = main:CreateCategory("Game")
local section = category:CreateSection("Teleports")

section:Create(
    "TextBox",
    "Teleport to Player",
    function(input)
        local new = input:gsub('%s+','')
        if new ~= "" and new ~= nil then
            for _, v in pairs(game:GetService('Players'):GetPlayers()) do
                if v.Name:lower():find(new:lower()) then
                    local cf = v.Character.HumanoidRootPart.CFrame
            	    _G.DogixLT2TPC(cf, gkey)
                end
            end
        end
    end,
    {
        text = ""
    }
)
section:Create(
    "TextBox",
    "Teleport to Player Base",
    function(input)
        local new = input:gsub('%s+','')
        if new ~= "" and new ~= nil then
            for _, v in pairs(game:GetService('Players'):GetPlayers()) do
                if v.Name:lower():find(new:lower()) then
                    for _,v1 in pairs (workspace.Properties:children()) do
                        if tostring(v1.Owner.Value) == v.Name then
                            local cf = v1.OriginSquare.Position
            	            _G.DogixLT2TP(cf.X, cf.Y+10, cf.Z, gkey)
            	        end
                    end
                end
            end
        end
    end,
    {
        text = ""
    }
)

local section = category:CreateSection("Shops")
section:Create("DropDown", "pp", function(current)
	if current == "WoodRUs" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(265, 3, 57))
	end
	if current == "Land Store" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(258, 3, -99))
	end
	if current == "Fancy Furnishings" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(491, 3, -1720))
	end
	if current == "Boxed Cars" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(509, 3.20000005, -1463))
	end
	if current == "Bob's Shack" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(260, 8, -2542))
	end
	if current == "link's Logic" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(4607, 9, -798))
	end
	if current == "Art Shop" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(5207, -156, 719))
	end
end, {
	options = {
		"WoodRUs",
		"Land Store",
		"Fancy Furnishings",
		"Boxed Cars",
		"Bob's Shack",
		"link's Logic",
		"Art Shop"
	},
	default = "Shops",
	search = false
})
local section = category:CreateSection("Wood Areas")
section:Create("DropDown", "hahha chronic skid brrrrrrrrrrrrrrrrrr", function(current)
	if current == "Volcano" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-1605, 623, 1083))
	elseif current == "End Times" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(113, -204, -951))
	elseif current == "Blue Wood" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(3488.1, -199.8, 519.1))
	elseif current == "Palm Islands" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(2585, -5, -17))
	elseif current == "Swamp" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-1209, 138, -801))
	elseif current == "SnowGlow" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-1105.9, -6, -894))
	elseif current == "Ice Wood" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(1560, 410, 3274))
	elseif current == "Cherry Meadow" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(220.9, 59.8, 1305.8))
	end
end, {
	options = {
		"Volcano",
		"End Times",
		"Blue Wood",
		"Palm Islands",
		"Swamp",
		"Cherry Meadow",
		"Ice Wood"
	},
	default = "Wood Areas",
	search = false
})
local section = category:CreateSection("Others")
section:Create("DropDown", "hahha chronic skid brrrrrrrrrrrrrrrrrr", function(current)
	if current == "Spawn" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(172, 2, 74))
	elseif current == "Secret Man" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(1061, 20, 1131))
	elseif current == "Shrine" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-1600, 205, 919))
	elseif current == "Cabin" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(1244, 66, 2306))
	elseif current == "Den" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(323, 49, 1930))
	elseif current == "Green Box" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-1675, 358, 1476))
	elseif current == "Birds Axe" then
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(4813.1, 33.5, -978.8))
		if current == "LightHouse" then
			game.Players.LocalPlayer.Character:MoveTo(Vector3.new(1464.8, 356.3, 3257.2))
		end
	end
end, {
	options = {
		"Spawn",
		"Secret Man",
		"Shrine",
		"Cabin",
		"Den",
		"Green Box",
		"Birds Axe",
		"LightHouse"
	},
	default = "Others",
	search = false
})

local section = category:CreateSection("Environment")
local AlwaysDay = false
section:Create("Toggle", "Always Day", function(state)
	AlwaysDay = state
	if AlwaysDay then
		AlwaysNight = false
		game.Lighting.TimeOfDay = "12:00:00"
	end
end, {
	default = false
})
local AlwaysNight = false
section:Create("Toggle", "Always Night", function(state)
	AlwaysNight = state
	if AlwaysNight then
		AlwaysDay = false
		game.Lighting.TimeOfDay = "00:00:00"
	end
end, {
	default = false
})
local NoFog = false
section:Create("Toggle", "No Fog", function(state)
	NoFog = state
	if NoFog then
		game.Lighting.FogEnd = math.huge
	else
		game.Lighting.FogEnd = 1500
	end
end, {
	default = false
})
game.Lighting.Changed:Connect(function()
	if NoFog then
		game.Lighting.FogEnd = 9999
	else
		game.Lighting.FogEnd = 1500
	end
	if AlwaysDay then
		game.Lighting.TimeOfDay = "12:00:00"
	end
	if AlwaysNight then
		game.Lighting.TimeOfDay = "00:00:00"
	end
end)
function ToggleWW()
	if _G.WaterWalk == true then
		for i, v in pairs(game:GetService("Workspace").Water:children()) do
			if v:IsA'Part' then
				v.CanCollide = true
			end
		end
	end
end
section:Create("Toggle", "Solid Water", function(state)
	if state then
		_G.WaterWalk = true
		ToggleWW()
	else
		_G.WaterWalk = false
		for i, v in pairs(game:GetService("Workspace").Water:children()) do
			if v:IsA'Part' then
				v.CanCollide = false
			end
		end
	end
end, {
	default = false
})

local section = category:CreateSection("Grey Auto Builds")
section:Create("DropDown", "DropDown", function(current)
	if current == "Castle" then
		loadstring(game:HttpGet("http://drizzy.wtf/PinkX/Auto/Castle", true))()
	elseif current == "Pyramid" then
		loadstring(game:HttpGet("http://drizzy.wtf/PinkX/Auto/Pyramid", true))()
	elseif current == "WoodRUs" then
		loadstring(game:HttpGet("http://drizzy.wtf/PinkX/Auto/WoodRUs", true))()
	elseif current == "Basic Wall (2 Tall)" then
		loadstring(game:HttpGet("http://drizzy.wtf/PinkX/Auto/Basic%20Wall%20(2%20Tall)", true))()
	elseif current == "Basic Wall (3 Tall)" then
		loadstring(game:HttpGet("http://drizzy.wtf/PinkX/Auto/Basic%20Wall%20(3%20Tall)", true))()
	elseif current == "Basic Wall (4 Tall)" then
		loadstring(game:HttpGet("http://drizzy.wtf/PinkX/Auto/Basic%20Wall%20(4%20Tall)", true))()
	elseif current == "Basic Wall (5 Tall)" then
		loadstring(game:HttpGet("http://drizzy.wtf/PinkX/Auto/Basic%20Wall%20(5%20Tall)", true))()
	elseif current == "Airplane" then
		loadstring(game:HttpGet("http://drizzy.wtf/PinkX/Auto/Airplane", true))()
	end
end, {
	options = {
		"Castle",
		"Pyramid",
		"WoodRUs",
		"Basic Wall (2 Tall)",
		"Basic Wall (3 Tall)",
		"Basic Wall (4 Tall)",
		"Basic Wall (5 Tall)",
		"Airplane"
	},
	default = "Castle",
	search = false
})
section:Create("Button", "Clear Grey Structures", function()
	for i, v in pairs(game.Workspace.PlayerModels:GetChildren()) do
		if v:FindFirstChild("Owner") and v:FindFirstChild("Type") and v.Owner.Value == game.Players.LocalPlayer then
			if v.Type.Value == "Structure" or v.Type.Value == "Furniture" then
				local A_1 = v
				local Event = game:GetService("ReplicatedStorage").Interaction.DestroyStructure
				Event:FireServer(A_1)
			end
		end
	end
end, {
	animated = true
})

section:Create("Toggle", "Auto-Fill All Blueprints Gray", function(db)
	if db then
		local cq = game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedStructure;
		for al, v in pairs(workspace.PlayerModels:GetChildren()) do
			if v:FindFirstChild("Owner") then
				if v:FindFirstChild("BuildDependentWood") and v:FindFirstChild("Type") then
					if v.Type.Value == "Blueprint" then
						local bX = nil;
						if v:FindFirstChild("MainCFrame") then
							bX = v.MainCFrame.Value
						else
							bX = v.PrimaryPart.CFrame
						end;
						cq:FireServer(v.ItemName.Value, bX, game:GetService'Players'.LocalPlayer, nil, v, true)
					end
				end
			end
		end;
		hX = workspace.PlayerModels.ChildAdded:connect(function(v)
			wait(0.3)
			if v:FindFirstChild("Owner") then
				if v:FindFirstChild("BuildDependentWood") and v:FindFirstChild("Type") then
					if v.Type.Value == "Blueprint" then
						local bX = nil;
						if v:FindFirstChild("MainCFrame") then
							bX = v.MainCFrame.Value
						else
							bX = v.PrimaryPart.CFrame
						end;
						cq:FireServer(v.ItemName.Value, bX, game:GetService'Players'.LocalPlayer, nil, v, true)
					end
				end
			end
		end)
	else
		if hX ~= nil then
			hX:Disconnect()
			hX = nil
		end
	end
end, {
	default = false
})

local section = category:CreateSection("Others")
section:Create("Button", "Better Graphics", function()
	_G.BlurSize = 3
	_G.ColorCorrectionBrightness = 0.03
	_G.ColorCorrectionContrast = 0.3
	_G.ColorCorrectionSaturation = 0.01
	_G.ColorCorrectionTintColor = Color3.fromRGB(244, 244, 244)
	_G.SunRaysIntensity = 0.2
	_G.SunRaysSpread = 1
	_G.GlobalShadows = true
	_G.Brightness = 0.9
	_G.GeographicLatitude = 350
	_G.TimeOfDay = 17
	_G.ExposureCompensation = 0.03
	spawn(function()
		_, i = pcall(function()
			Lighting = game:GetService("Lighting")
			Blur = Instance.new("BlurEffect", Lighting)
			Color = Instance.new("ColorCorrectionEffect", Lighting)
			Sun = Instance.new("SunRaysEffect", Lighting)
			Blur.Enabled = not false
			Blur.Size = _G.BlurSize
			Color.Enabled = not false
			Color.Brightness = _G.ColorCorrectionBrightness
			Color.Contrast = _G.ColorCorrectionContrast
			Color.Saturation = _G.ColorCorrectionSaturation
			Color.TintColor = _G.ColorCorrectionTintColor
			Sun.Enabled = not false
			Sun.Intensity = _G.SunRaysIntensity
			Sun.Spread = _G.SunRaysSpread
			print("Finished setting mood")
			function loadLighting()
				Lighting.GlobalShadows = _G.GlobalShadows
				Lighting.Brightness = _G.Brightness
				Lighting.GeographicLatitude = _G.GeographicLatitude
				Lighting.TimeOfDay = _G.TimeOfDay
				Lighting.ExposureCompensation = _G.ExposureCompensation
			end
			loadLighting()
		end)
		if i and not _ then
			print("ERROR: "..i)
		else
			print("Loaded HD Graphics")
		end
	end)
end, {
	animated = true
})
section:Create("Button", "Delete Water", function()
	for i, v in pairs(game.Workspace.Water:GetChildren()) do
		if v.Name == "Water" then
			v:Destroy()
		end
	end
	for i, v in pairs(game.Players.LocalPlayer.PlayerGui.Scripts:GetChildren()) do
		if v.Name == "CharacterFloat" then
			v:Destroy()
		else
		end
	end
	print("you removed the water poggers")
end, {
	animated = true
})
section:Create("Button", "Remove Trees", function()
	spawn(function()
		for i, v in pairs(game.Workspace:GetChildren()) do
			if v.Name == "TreeRegion" then
				spawn(function()
					for a, b in pairs(v:GetChildren()) do
						if b.Name == "Model" then
							game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(b)
							game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(b)
						end
					end
				end)
			end
		end
	end)
end, {
	animated = true
})

local category = main:CreateCategory("Misc")
local otherPlayerOptions = category:CreateSection("Miscellaneous")
otherPlayerOptions:Create("DropDown", "Select a player", function(plr)
	KickPlayer = plr
	print(KickPlayer)
end, {
	playerlist = true
}) -- yes i can
otherPlayerOptions:Create("Button", "Kick Player", function()
	Kick(KickPlayer)
end, {
	animated = true
})
otherPlayerOptions:Create("Button", "Kill Player", function()
	Kill(KickPlayer)
end, {
	animated = true
})
local section = category:CreateSection("Kill Methods")
section:Create("DropDown", "Kill Methods", function(current)
	killMethod = current
end, {
	options = {
		"Volcano",
		"EndTimes",
		"Ocean",
		"Birds Axe",
		"Maze",
		"Palm Island",
		"Pink Wood",
		"Land Store",
		"Volcano trap"
	},
	default = "Volcano",
	search = false
})
local section = category:CreateSection("Others")
section:Create("Button", "Anti Blacklist", function()
	for i, v in pairs(game.Players:GetPlayers()) do
		if v.BlacklistFolder:FindFirstChild(game.Players.LocalPlayer.Name) then
			v.BlacklistFolder[game.Players.LocalPlayer.Name]:Destroy()
		end
	end
	game.Workspace.Effects.ChildAdded:connect(function()
		for i, v in pairs(game.Players:GetPlayers()) do
			if v.BlacklistFolder:FindFirstChild(game.Players.LocalPlayer.Name) then
				v.BlacklistFolder[game.Players.LocalPlayer.Name]:Destroy()
			end
		end
	end)
	local plr = game.Players.LocalPlayer
	local cframe
	for i, v in next, workspace:GetDescendants() do
		if v:IsA("SpawnLocation") then
			v.Touched:Connect(function(h)
				if h.Parent == plr.Character and cframe then
					plr.Character:SetPrimaryPartCFrame(cframe)
				end
			end)
		end
	end
	game:GetService("RunService"):BindToRenderStep("NO HACKS", Enum.RenderPriority.Last.Value, function()
		if game.Players.LocalPlayer.Character.PrimaryPart then
			cframe = game.Players.LocalPlayer.Character.PrimaryPart.CFrame
		end
	end)
	for i, v in next, debug.getregistry() do
		if type(v) == 'function' and debug.getupvalues(v).lastUpdate then
			debug.setupvalue(v, "lastUpdate", math.huge)
			break
		end
	end
end, {
	animated = true
})
local plr = game.Players.LocalPlayer
local clientDrag = game:GetService('ReplicatedStorage').Interaction.ClientIsDragging
local clientRequest = game:GetService('ReplicatedStorage').Interaction.ClientRequestOwnership
local Owner = nil
local item = nil
local items = {}
if not workspace:FindFirstChild'CordFolder' then
	local folder = Instance.new("Folder", workspace)
	folder.Name = "CordFolder"
end
local cords = workspace.CordFolder:FindFirstChild'CordPart'
function checkCord()
	for i, v in pairs(workspace.CordFolder:GetChildren()) do
		if v.Name == 'CordPart' then
			cords = v
		end
	end
end
function baseDrop(itemstobd)
	checkCord()
	for i, v in pairs(workspace.PlayerModels:children()) do
		if v:FindFirstChild'Owner' and v.Owner.Value == game.Players[Owner] then
			if v:FindFirstChild'Main' and v:FindFirstChild'ItemName' and v.ItemName.Value == item or v:FindFirstChild'ToolName' and v.ToolName == item then
				if (plr.Character.HumanoidRootPart.CFrame.p - v.Main.CFrame.p).magnitude < 25 then
					clientRequest:FireServer(v.Main)
					clientDrag:FireServer(v.Main)
					v.Main.CFrame = cords.CFrame + Vector3.new(0, 10, 0)
					v.Main.Sexy:Destroy()
					wait(.06)
				elseif (plr.Character.HumanoidRootPart.CFrame.p - v.Main.CFrame.p).magnitude > 25 then
					teleport(CFrame.new(v.Main.CFrame.p))
					clientRequest:FireServer(v.Main)
					clientDrag:FireServer(v.Main)
					v.Main.CFrame = cords.CFrame + Vector3.new(0, 10, 0)
					wait(.150)
					v.Main.Sexy:Destroy()
				end
			end
		end
	end
end
local category = main:CreateCategory("Base Drop")
local section = category:CreateSection("Base Drop")
section:Create("Textlabel", "Works Best in VIP server!")
section:Create("DropDown", "Owner", function(current)
	Owner = current
end, {
	playerlist = true
})
section:Create("DropDown", "Item to basedrop", function(current)
	for i, v in pairs(workspace.PlayerModels:children()) do
		if v:FindFirstChild'Owner' and v.Owner.Value == game.Players[Owner] then
			if v:FindFirstChild'Main' and v:FindFirstChild'ItemName' and v.ItemName.Value == current then
				item = current
				itemMain = v.Main
				table.insert(items, item)
				if not itemMain:FindFirstChild("Sexy") then
					local Box = Instance.new("SelectionBox", itemMain)
					Box.Name = "Sexy"
					Box.Adornee = itemMain
				else
					itemMain.Sexy:Destroy()
				end
			elseif v:FindFirstChild'WoodSection' and v:FindFirstChild'TreeClass' and v.TreeClass.Value == current then
				item = current
			end
		end
	end
end, {
	options = {"BasicHatchet";"Axe1";"Axe2";"Axe3";"SilverAxe";"ManyAxe";"Rukiryaxe";"Wire";"NeonWireOrange";"NeonWireRed";"NeonWireViolet";"NeonWireWhite";"NeonWireYellow";"NeonWireBlue";"NeonWireCyan";"NeonWireGreen";"IcicleWireBlue";"IcicleWireAmber";"IcicleWireRed";"IcicleWireGreen";"IcicleWireHalloween";"LightBulb";"BagOfSand";"CanOfWorms";"Dynamite";"Sawmill";"Sawmill2";"Sawmill3";"Sawmill4";"Sawmill4L";"UtilityTruck";"WorkLight";"SmallTrailer";"Pickup1";"UtilityTruck2";"Trailer2";"Painting1";"Painting2";"Painting3";"Painting6";"Painting7";"Painting8";"Painting9";"ChopSaw";"Button0";"Lever0";"Laser";"LaserReceiver";"Hatch";"SignalDelay";"SignalSustain";"WoodChecker";"GateNOT";"GateXOR";"GateAND";"GateOR";"ClockSwitch";"PressurePlate";"ConveyorSwitch";"StraightSwitchConveyorLeft";"StraightSwitchConveyorRight";"ConveyorSupports";"StraightConveyor";"TightTurnConveyorSupports";"TightTurnConveyor";"ConveyorFunnel";"TiltConveyor";"LogSweeper";"Seat_Armchair";"Dishwasher";"Refridgerator";"Stove";"Toilet";"Seat_Couch";"Seat_Loveseat";"FloorLamp1";"Lamp1";"GlassPane1";"GlassPane2";"GlassPane3";"GlassPane4";"GlassDoor1";"FireworkLauncher";"Bed1";"Bed2";"WallLight1";"WallLight2"},
	search = true
})
section:Create("Button", "Set Coordinates", function()
	for i, v in pairs(workspace.CordFolder:GetChildren()) do
		if v.Name == 'CordPart' then
			v:Destroy()
			cords = nil
		end
	end
	local cords = Instance.new("Part")
	cords.Parent = game.Workspace.CordFolder
	cords.Name = "CordPart"
	cords.Position = plr.Character.HumanoidRootPart.Position
	cords.Material = ("Neon")
	cords.Color = Color3.fromRGB(255, 115, 232)
	cords.Anchored = true
	cords.CanCollide = false
	cords.Size = Vector3.new(1, 1, 1)
end, {
	animated = true
})
section:Create("Button", "Destroy Coordinates", function()
	for i, v in pairs(workspace.CordFolder:GetChildren()) do
		if v.Name == 'CordPart' then
			v:Destroy()
			cords = nil
		end
	end
end, {
	animated = true
})
section:Create("Button", "Basedrop Items", function()
	for i, v in pairs(items) do
		baseDrop(v.Main, game.Workspace.CordFolder.CordPart.CFrame)
	end
	items = {}
end, {
	animated = true
})
local category = main:CreateCategory("Auto Buy")
local current_item = "BasicHatchet"
local current_qty = "BasicHatchet"
local section = category:CreateSection("Auto Buy")
local information = {
	["WoodRUs"] = {
		Cashier = workspace.Stores.WoodRUs.Thom,
		ID = 10,
		TargetItem = {
			"BasicHatchet",
			"Axe2"
		}
	},
	["FurnitureStore"] = {
		Cashier = workspace.Stores.FurnitureStore.Corey,
		ID = 11,
		TargetItem = {
			"Bed1",
			"Seat_Couch"
		}
	},
	["CarStore"] = {
		Cashier = workspace.Stores.CarStore.Jenny,
		ID = 12,
		TargetItem = {
			"Trailer2",
			"UtilityTruck2"
		}
	},
	["ShackShop"] = {
		Cashier = workspace.Stores.ShackShop.Bob,
		ID = 13,
		TargetItem = {
			"Dynamite",
			"CanOfWorns"
		}
	},
	["FineArt"] = {
		Cashier = workspace.Stores.FineArt.Timothy,
		ID = 14,
		TargetItem = {
			"Painting1",
			"Painting1"
		}
	},
	["LogicStore"] = {
		Cashier = workspace.Stores.LogicStore.Lincoln,
		ID = 15,
		TargetItem = {
			"NeonWireOrange",
			"Hatch"
		}
	}
}
getgenv().isnetworkowner = isnetworkowner or is_network_owner or nil
function getItemInfo(itemName)
	for i, v in pairs(workspace.Stores:GetChildren()) do
		if v:FindFirstChild(itemName) then
			for i2, v2 in pairs(information) do
				for i3, v3 in pairs(v2.TargetItem) do
					if v:FindFirstChild(v3) then
						v2.StoreItems = v
						return v2
					end
				end
			end
		end
	end
	return false
end
function autobuyItem(itemName, quantity)
	local info = getItemInfo(itemName)
	local original = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
	for i = 1, quantity do
		local item = info.StoreItems:FindFirstChild(itemName)
		local counter = info.Cashier.Parent.Counter
		local done_buying = nil
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = item.Main.CFrame + Vector3.new(5, 0, 5)
		wait(0.1)
		for i = 1, 20 do
			item:SetPrimaryPartCFrame(counter.CFrame)
			game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(item)
			wait()
			if isnetworkowner then
				if isnetworkowner(item.Main) then
					break
				end
			end
		end
		local purchase_detector = workspace.PlayerModels.ChildAdded:connect(function(v)
			wait(0.1)
			if v == item then
				done_buying = v
			end
		end)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = counter.CFrame + Vector3.new(5, 0, 5)
		local firetable = {
			["Character"] = info.Cashier,
			["Name"] = info.Cashier.Name,
			["ID"] = info.ID
		}
		wait(0.1)
		repeat
			wait(0.1)
			game.ReplicatedStorage.NPCDialog.PlayerChatted:InvokeServer(firetable, "Initiate")
			game.ReplicatedStorage.NPCDialog.PlayerChatted:InvokeServer(firetable, "ConfirmPurchase")
			game.ReplicatedStorage.NPCDialog.PlayerChatted:InvokeServer(firetable, "EndChat")
		until done_buying ~= nil
		purchase_detector:Disconnect()
		purchase_detector = nil
		item = done_buying
		for i = 1, 10 do
			if isnetworkowner then
				if isnetworkowner(item.Main) then
					item:SetPrimaryPartCFrame(original)
					break
				end
			end
			item:SetPrimaryPartCFrame(original)
			game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(item)
			wait()
		end
	end
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = original
end
local list = {}
for i, v in pairs(workspace.Stores:GetChildren()) do
	if v.Name == "ShopItems" then
		for i, v2 in pairs(v:GetChildren()) do
			if v2.Type.Value ~= "Blueprint" then
				if not table.find(list, v2.Name) then
					table.insert(list, v2.Name)
				end
			end
		end
	end
end
section:Create("DropDown", "Item", function(current)
	current_item = current
end, {
	options = list,
	default = current_item,
	search = true
})
section:Create("Slider", "Amount", function(value)
	current_qty = value
end, {
	min = 1,
	max = 25,
	default = 1,
	changablevalue = true
})
section:Create("Button", "Purchase", function()
	autobuyItem(current_item, current_qty)
end, {
	animated = true
})
wait(1)
notify("Auto Buy", "Updating auto buy")
