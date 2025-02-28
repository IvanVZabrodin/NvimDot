local M = {}

M.record = true
-- M.timeline = {}

M.emitters = {}

local anonymous_count = 0

M.Emitter = function (name)
	local U = { name = name or ("anon#" .. anonymous_count), events = {} }
	if not name then anonymous_count = anonymous_count + 1 end

	function U:on(event, callback, priority)
		if self.events[event] == nil then self.events[event] = { name = event, callbacks = { max = 1 } } end
		if self.events[event].callbacks[priority] == nil then self.events[event].callbacks[priority] = {} end
		table.insert(self.events[event].callbacks[priority], callback)
		if priority > self.events[event].callbacks.max then self.events[event].callbacks.max = priority end
		if M.record then table.insert(M.timeline, { action = "registered", data = { event = event, priority = priority, callback = callback } }) end
	end

	function U:emit(event, args)
		local callbacks = self.events[event].callbacks
		for priority = 1, callbacks.max do
			if callbacks[priority] then
				for _, c in ipairs(callbacks[priority]) do
					c(args)
				end
			end
		end
		if M.record then table.insert(M.timeline, { action = "emit", data = { event = event, args = args } }) end
	end

	M.emitters[U.name] = U
	return U
end

local timelines = { anon_count = 0 }

timelines.create = function (name, record)
	if not name then
		name = "anon#" .. timelines.anon_count
		timelines.anon_count = timelines.anon_count + 1
	end

	local U = { name = name, emitters = {}, anon_count = 0 }
	if record then U.history = {} end

	function U:Emitter (ename)
		if not ename then
			ename = "anon#" .. self.anon_count
			self.anon_count = self.anon_count + 1
		end

		local V = { name = ename, events = {} }

		function V:on(event, callback, priority)
			self.events[event] = self.events[event] or { name = event, callbacks = { max = 1 } }
			self.events[event].callbacks[priority] = self.events[event].callbacks[priority] or {}
			table.insert(self.events[event].callbacks[priority], callback)
			if priority > self.events[event].callbacks.max then self.events[event].callbacks.max = priority end
		end

		function V:emit(event, args)
			local cbacks = self.events[event].callbacks
			for p = 1, cbacks.max do
				if cbacks[p] then
					for _, c in ipairs(cbacks[p]) do
						c(args)
					end
				end
			end
		end

		self.emitters[ename] = V

		return V
	end

	function U:emit(emitter, event, args)
		self.emitters[emitter]:emit(event, args)
	end

	function U:execute(schedule)
		for _, i in ipairs(schedule) do

		end
	end

	return U
end

return timelines.create
