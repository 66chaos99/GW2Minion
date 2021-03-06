local tbl = 
{
	class = "SubTree",
	nodes = 
	{
		
		{
			class = "AlwaysSucceed",
			nodes = 
			{
				
				{
					class = "Sequence",
					nodes = 
					{
						
						{
							class = "Action",
							nodes = 
							{
							},
							settings = 
							{
							},
							variables = 
							{
								finishcode = "",
								info = "",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "if (context.movetorandom_randompoint == nil) then\n\t\tif(ml_global_information.Player_OnMesh) then\n\t\t\t\t\t\tPlayer:StopMovement()\n\t\t\t\t\t\tcontext.movetorandom_randompoint = gw2_common_functions.GetRandomPoint()\n\t\telse\n\t\t\t\t-- Select the nearest waypoint so we at least have somewhere to go if we start offmesh\n\t\t\t\tlocal WPList = WaypointList()\n\t\t\t\tlocal nearesst = nil\n    local nearestdist = 99999999\n    for wid,wpentry in pairs(WPList) do\n       if(wpentry.contested == 0 and wpentry.onmesh and ( not nearesst or (wpentry.distance < nearestdist))) then\n          nearestdist = wpentry.distance\n          nearesst = wpentry\n       end\n    end\n\t\t\t\tif(nearesst and nearesst.pos) then\n\t\t\t\t\t\tcontext.movetorandom_randompoint = wp.pos\n\t\t\t\tend\n\t\tend\nend\n\nif(table.valid(context.movetorandom_randompoint)) then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
								startcode = "",
							},
						},
						
						{
							class = "PrioritySelector",
							nodes = 
							{
								
								{
									class = "Action",
									nodes = 
									{
									},
									settings = 
									{
									},
									variables = 
									{
										finishcode = "",
										info = "",
										monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
										runcode = "if(table.valid(context.movetorandom_randompoint) and context.moveto_stoppingdistance) then\n\t\tlocal dist = math.distance3d(context.movetorandom_randompoint,ml_global_information.Player_Position)\n\t\tif(dist <= context.moveto_stoppingdistance or dist < 150) then\n\t\t\t\tcontext.movetorandom_randompoint = nil\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\nend\nself:fail()",
										startcode = "",
									},
								},
								
								{
									class = "Sequence",
									nodes = 
									{
										
										{
											class = "Action",
											nodes = 
											{
											},
											settings = 
											{
											},
											variables = 
											{
												finishcode = "",
												info = "",
												monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
												runcode = "if(table.valid(context.movetorandom_randompoint)) then\n\t\tcontext.moveto_position = context.movetorandom_randompoint\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
												startcode = "",
											},
										},
										
										{
											class = "SubTree",
											nodes = 
											{
											},
											settings = 
											{
												randomMovement = true,
												randomizestoppingdistance = true,
												smoothturns = true,
												stoppingdistance = 750,
												stoppingidstancemaxrange = 2000,
												usewaypoints = false,
											},
											variables = 
											{
												filename = "MoveTo.st",
											},
										},
									},
									settings = 
									{
									},
									variables = 
									{
										info = "",
										monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.actualTask or 'None'))",
									},
								},
							},
							settings = 
							{
							},
							variables = 
							{
								info = "",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.runningTask or 'None'))",
							},
						},
					},
					settings = 
					{
					},
					variables = 
					{
						info = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.actualTask or 'None'))",
					},
				},
			},
			settings = 
			{
			},
			variables = 
			{
				info = "",
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
			},
		},
	},
	settings = 
	{
	},
	variables = 
	{
		filename = "MoveToRandom.st",
		finishcode = "",
		info = "Move to random",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)\n\nif(context) then\n\t\tif(context.movetorandom_randompoint) then\n\t\t\t\tlocal dist = math.distance3d(ml_global_information.Player_Position,context.movetorandom_randompoint)\n\t\t\t\tGUI:Text(\"Distance: \" .. tostring(math.round(dist,2)))\n\t\t\t\tGUI:Text(\"Stopping distance: \" .. tostring(context.moveto_stoppingdistance))\n\t\t\t\tGUI:Text(\"Distance to end pos: \" .. tostring(math.round(dist-context.moveto_stoppingdistance,2)))\n\t\tend\nend",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
	},
}



return tbl