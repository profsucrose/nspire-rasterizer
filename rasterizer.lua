-- Simple voxal engine script for the TI-Nspire CX

-- // DATA STRUCTURES \\ --

-- 2x1 Vector
Vec2 = class()

function Vec2:init(x, y)
    if x == nil then error("Tried to create a vector with x component nil")
    elseif y == nil then error("Tried to create a vector with y-component nil")
    end

    o = {}
    setmetatable(o, self)
    self.__index = self
    self[0] = x
    self[1] = y
    return o
end

function Vec2:set(index, value)
    if     index == 0 then self[0] = value
    elseif index == 1 then self[1] = value
    else error(string.format("Index %d out of bounds for setting Vec2 component", index))
    end
end
-----

-- 3x1 Vector
Vec3 = class()

function Vec3:init(x, y, z)
    if x == nil then error("Tried to create a vector with x component nil")
    elseif y == nil then error("Tried to create a vector with y-component nil")
    elseif z == nil then error("Tried to create a vector with z-component nil")
    end

    o = {}
    setmetatable(o, self)
    self.__index = self
    self[0] = x
    self[1] = y
    self[2] = z
    return o
end

function Vec3:print(name)
    print(name, ":", self[0], self[1], self[2])
end

function Vec3:add(vector)
    return Vec3(
        self[0] + vector[0],
        self[1] + vector[1],
        self[2] + vector[2]
    )
end

function Vec3:sub(vector)
    return Vec3(
        self[0] - vector[0],
        self[1] - vector[1],
        self[2] - vector[2]
    )
end

function Vec3:cross(vector)
    return Vec3(
        self[1] * vector[2] - self[2] * vector[1],
        self[2] * vector[0] - self[0] * vector[2],
        self[0] * vector[1] - self[1] * vector[0]
    )
end

function Vec3:scale(scalar)
    return Vec3(
        scalar * self[0],
        scalar * self[1],
        scalar * self[2]
    )
end

function Vec3:divide(scalar)
    return self:scale(1/scalar)
end

function Vec3:magnitude()
    return math.sqrt(math.pow(self[0], 2) + math.pow(self[1], 2) + math.pow(self[2], 2))
end

function Vec3:dot(vector)
    return self[0] * vector[0] + self[1] * vector[1] + self[2] * vector[2]
end

function Vec3:normalize()
    return self:divide(self:magnitude())
end

function Vec3:world2screen()
    return Vec3((self[0] + 1) * WIDTH / 2 + 0.5, (self[1] + 1) * HEIGHT / 2 + 0.5, self[2])
end
-----

-- 4x1 Vector
Vec4 = class()

function Vec4:init(x, y, z, w)
    if x == nil then error("Tried to create a vector with x component nil")
    elseif y == nil then error("Tried to create a vector with y-component nil")
    elseif z == nil then error("Tried to create a vector with z-component nil")
    elseif w == nil then error("Tried to create a vector with w-component nil")
    end

    o = {}
    setmetatable(o, self)
    self.__index = self
    self[0] = x
    self[1] = y
    self[2] = z
    self[3] = w
    return o
end

function Vec4:print(name)
    print(name, ":", self[0], self[1], self[2], self[3])
end

function Vec4:add(vector)
    return Vec4(
        self[0] + vector[0],
        self[1] + vector[1],
        self[2] + vector[2],
        self[3] + vector[3]
    )
end

function Vec4:sub(vector)
    return Vec4(
        self[0] - vector[0],
        self[1] - vector[1],
        self[2] - vector[2],
        self[3] - vector[3]
    )
end

function Vec4:cross(vector)
    return Vec4(
        self[1] * vector[2] - self[2] * vector[1],
        self[2] * vector[0] - self[0] * vector[2],
        self[0] * vector[1] - self[1] * vector[0],
        1
    )
end

function Vec4:scale(scalar)
    return Vec4(
        scalar * self[0],
        scalar * self[1],
        scalar * self[2],
        scalar * self[3]
    )
end

function Vec4:divide(scalar)
    return self:scale(1/scalar)
end

function Vec4:magnitude()
    return math.sqrt(math.pow(self[0], 2) + math.pow(self[1], 2) + math.pow(self[2], 2) + math.pow(self[3], 2))
end

function Vec4:dot(vector)
    return self[0] * vector[0] + self[1] * vector[1] + self[2] * vector[2] + self[3] * vector[3]
end

function Vec4:normalize()
    return self:divide(self:magnitude())
end

function Vec4:world2screen()
    return Vec4((self[0] + 1) * WIDTH / 2 + 0.5, (self[1] + 1) * HEIGHT / 2 + 0.5, self[2], 1)
end
-----

-- 4x4 Matrix
Matrix4 = class()
function Matrix4:init(row0, row1, row2, row3)
    if row0 == nil then error("Tried to create a 4x4 matrix with first row nil")
    elseif row1 == nil then error("Tried to create a 4x4 matrix with second row nil")
    elseif row2 == nil then error("Tried to create a 4x4 matrix with third row nil")
    elseif row3 == nil then error("Tried to create a 4x4 matrix with fourth row nil")
    end

    o = {}
    setmetatable(o, self)
    self.__index = self
    self[0] = row0
    self[1] = row1
    self[2] = row2
    self[3] = row3
    return o
end

function Matrix4:identity()
    return Matrix4(
        Vec4(1, 0, 0, 0),
        Vec4(0, 1, 0, 0),
        Vec4(0, 0, 1, 0),
        Vec4(0, 0, 0, 1)
    )
end

function Matrix4:mul(matrix)
    local result = Matrix4(matrix[0], matrix[1], matrix[2], matrix[3])
    for row = 0, 3, 1 do
        for col = 0, 3, 1 do
            result[row][col] = self[row][0] * matrix[0][col]
                + self[row][1] * matrix[1][col]
                + self[row][2] * matrix[2][col]
                + self[row][3] * matrix[3][col]
        end
    end
    return result
end

function Matrix4:scale(x, y, z)
	return Matrix4(
		Vec4(x, 0, 0, 0),
		Vec4(0, y, 0, 0),
		Vec4(0, 0, z, 0),
		Vec4(0, 0, 0, 1)
	)
end

function Matrix4:rotationZ(theta)
	theta = theta * math.pi / 180
	local sinTheta = math.sin(theta)
	local cosTheta = math.cos(theta)
	return Matrix4(
		Vec4( cosTheta, -sinTheta, 0, 0),
		Vec4( sinTheta,  cosTheta, 0, 0),
		Vec4( 0,          0,       1, 0),
		Vec4( 0,          0,       0, 1)
	)
end

function Matrix4:rotationY(theta)
	theta = theta * math.pi / 180
	local sinTheta = math.sin(theta)
	local cosTheta = math.cos(theta)
	return Matrix4(
		Vec4(cosTheta, 0, -sinTheta, 0),
		Vec4(       0, 1,         0, 0),
		Vec4(sinTheta, 0,  cosTheta, 0),
		Vec4(       0, 0,         0, 1)
	)
end

function Matrix4:rotationX(theta)
	theta = theta * math.pi / 180
	local sinTheta = math.sin(theta)
	local cosTheta = math.cos(theta)
	return Matrix4(
		Vec4(1,        0,         0, 0),
		Vec4(0, cosTheta, -sinTheta, 0),
		Vec4(0, sinTheta,  cosTheta, 0),
		Vec4(0,        0,         0, 1)
	)
end

function Matrix4:viewport(x, y, w, h)
    local matrix = Matrix4:identity()
    matrix[0][3] = x + w / 2
    matrix[1][3] = y + h / 2
    matrix[2][3] = DEPTH / 2

    matrix[0][0] = w / 2
    matrix[1][1] = h / 2
    matrix[2][2] = DEPTH / 2
    return matrix
end

function Matrix4:projection(z)
    local result = Matrix4:identity()
    result[3][2] = -1 / z
    return result
end

function Matrix4:toVector()
    -- divide by homogenous coordinate
    return Vec3(self[0][0] / self[3][0], self[1][0] / self[3][0], self[2][0] / self[3][0])
end

function Matrix4:fromVector(vector)
    local result = Matrix4:identity()
    result[0][0] = vector[0]
    result[1][0] = vector[1]
    result[2][0] = vector[2]
    result[3][0] = 1
    return result
end

function Matrix4:lookat(eye, center, up)
    local z = eye:sub(center):normalize()
    local x = up:cross(z):normalize()
    local y = z:cross(x):normalize()
    local minv = Matrix4:identity()
    local tr = Matrix4:identity()
    for i = 0, 2, 1 do
        minv[0][i] = x[i]
        minv[1][i] = y[i]
        minv[2][i] = z[i]
        tr[i][3] = -center[i]
    end
    return minv:mul(tr)
end

-- // GLOBALS \\ --
WIDTH = platform.window:width()     -- 318
HEIGHT = platform.window:height()   -- 212
DEPTH = 255
INF = 1/0

-- // PROGRAM \\ --

-- Drawing Utils
function setColor(gc, color)
    gc:setColorRGB(math.min(color[0] * 255, 255), math.min(color[1] * 255, 255), math.min(color[2] * 255, 255))
end

function set(gc, x, y)
    gc:fillRect(x, HEIGHT - y, 1, 1)
end

function line(gc, x0, y0, x1, y1)
    -- gc:drawLine(x0, HEIGHT - y0, x1, HEIGHT - y1)
    local steep = false
    if math.abs(x0 - x1) < math.abs(y0 - y1) then
		x0, y0 = y0, x0
		x1, y1 = y1, x1
    end
    if (x0 > x1) then
		x0, x1 = x1, x0
		y0, y1 = y1, y0
    end
    local dx = x1 -x0
    local dy = y1 -y0
    local derror = math.abs(dy / dx)
    local error = 0
    local y = y0

    for x = x0, x1, 1 do
        local drawX = x
        local drawY = y
        if steep then
			drawX, drawY = drawY, drawX
        end
        set(gc, drawX, drawY)
        error = error + derror
        if error > .5 then
            if y1 > y0 then y = y + 1
            else y = y - 1 end
            error = error - 1
        end
    end
end

function barycentric(v0, v1, v2, point)
    local s = {}
    for i = 0, 2, 1 do
        s[i] = Vec3(v2[i] - v0[i], v1[i] - v0[i], v0[i] - point[i])
    end
    local u = s[0]:cross(s[1])
    if math.abs(u[2]) > 1e-2 then
        return Vec3(1 - (u[0] + u[1]) / u[2], u[1] / u[2], u[0] / u[2])
    end
    return Vec3(-1, 1, 1)
end

-- Rasterize triangle using barycentric coordinates
function triangle(gc, vertices, zbuffer)
    local bboxmin = Vec2(INF, INF)
    local bboxmax = Vec2(-INF, -INF)
    local clamp = Vec2(WIDTH - 1, HEIGHT - 1)
    for i = 0, 2, 1 do
        for j = 0, 1, 1 do
            bboxmin:set(j, math.max(0, math.min(bboxmin[j], vertices[i][j])))
            bboxmax:set(j, math.min(clamp[j], math.max(bboxmax[j], vertices[i][j])))
        end
    end
    for x = bboxmin[0], bboxmax[0], 1 do
        for y = bboxmin[1], bboxmax[1], 1 do
            local bcScreen = barycentric(vertices[0], vertices[1], vertices[2], Vec3(x, y, 0))
            -- bcScreen:print("BC Coord")
            if bcScreen[0] >= -0.08 and bcScreen[1] >= -0.08 and bcScreen[2] >= -0.08 then
                -- print("Drawing coord")
                local z = 0
                for i = 0, 2, 1 do
                    z = z + vertices[i][2] * bcScreen[i]
                end
                local index = math.floor(x) + math.floor(y) * WIDTH
                local bufferValue = zbuffer[index]
                -- print("X:", x, "Y:", y, "Z:", z, "Index:", index, "Buffer:", bufferValue)
                if bufferValue == nil or bufferValue < z then
                    zbuffer[index] = z
                    set(gc, x, y)
                end
            end
        end
    end
end

function triangleLineSweep(gc, v0, v1, v2, zbuffer)
    if v0[1] == v1[1] and v0[1] == v2[1] then
        return
    end

    -- bubble sort vertices by y-coordinate
    if v0[1] > v1[1] then
        local tmp = v0
        v0 = v1
        v1 = tmp
    end
    if v0[1] > v2[1] then
        local tmp = v0
        v0 = v2
        v2 = tmp
    end
    if v1[1] > v2[1] then
        local tmp = v1
        v1 = v2
        v2 = tmp
    end

    local totalHeight = v2[1] - v0[1]
    for y = v0[1], v1[1], 1 do
        local segmentHeight = v1[1] - v0[1] + 1
        local alpha = (y - v0[1]) / totalHeight
        local beta = (y - v0[1]) / segmentHeight
        local a = v0:add(v2:sub(v0):scale(alpha))
        local b = v0:add(v1:sub(v0):scale(beta))
        if a[0] > b[0] then
            local tmp = a
            a = b
            b = tmp
        end
        for x = a[0], b[0], 1 do
            local bcScreen = barycentric(v0, v1, v2, Vec3(x, y, 0))
            -- bcScreen:print("BC Coord")
                -- print("Drawing coord")
                local z = v0[2] * bcScreen[0] + v1[2] * bcScreen[1] + v2[2] * bcScreen[2]
                local index = math.floor(x) + math.floor(y) * WIDTH
                local bufferValue = zbuffer[index]
                -- print("X:", x, "Y:", y, "Z:", z, "Index:", index, "Buffer:", bufferValue)
                if bufferValue == nil or bufferValue < z then
                    zbuffer[index] = z
                    set(gc, x, y)
                end
        end
    end
    for y = v1[1], v2[1], 1 do
        local segmentHeight = v2[1] - v1[1] + 1
        local alpha = (y - v0[1]) / totalHeight
        local beta = (y - v1[1]) / segmentHeight
        local a = v0:add(v2:sub(v0):scale(alpha))
        local b = v1:add(v2:sub(v1):scale(beta))
        if a[0] > b[0] then
            local tmp = a
            a = b
            b = tmp
        end
        for x = a[0], b[0], 1 do
            local bcScreen = barycentric(v0, v1, v2, Vec3(x, y, 0))
            local z = v0[2] * bcScreen[0] + v1[2] * bcScreen[1] + v2[2] * bcScreen[2]
            local index = math.floor(x) + math.floor(y) * WIDTH
            local bufferValue = zbuffer[index]
            if bufferValue == nil or bufferValue < z then
                zbuffer[index] = z
                set(gc, x, y)
            end
        end
    end
end
------

-- Obj parser
Model = class()

function Model:init(OBJ)
    if OBJ == nil then
        error("Cannot initialize model with nil OBJ path")
    end

    local o = { __index = self }
    setmetatable(o, self)
    self.vertices = {}
    self.faces = {}

    self.nfaces = 0
    local nvertices = 0
    for _, line in ipairs(OBJ) do
        local lineType = string.sub(line, 1, 2)
        if lineType == "v " then
            local v = Vec3(
                string.match(line, "v ([-%d.e]+)"),
                string.match(line, "v [-%d.e]+ ([-%d.e]+)"),
                string.match(line, "v [-%d.e]+ [-%d.e]+ ([-%d.e]+)")
            )
            self.vertices[nvertices] = v
            print(string.format("Line: %s\nVertex: (%s, %s, %s)", line, v[0], v[1], v[2]))
            nvertices = nvertices + 1
        elseif lineType == "f " then
            -- OBJ indices start at 1
            local f = Vec3(
                string.match(line, "f (%d+)") - 1,
                string.match(line, "f [%d/]+ (%d+)") - 1,
                string.match(line, "f [%d/]+ [%d/]+ (%d+)") - 1
            )
            self.faces[self.nfaces] = f
            self.nfaces = self.nfaces + 1
        end
    end

    print(string.format("Loaded %d vertices, %d faces", nvertices, self.nfaces))

    return o
end

-- render model as wireframe
function Model:drawWireframe(gc)
    local color = Vec3(0, 0, 0)
    setColor(gc, color)
    for i = 0, self.nfaces - 1, 1 do
        local face = self.faces[i]
        for j = 0, 2, 1 do
            local v0 = self.vertices[math.floor(face[j])]
            local v1 = self.vertices[math.floor(face[(j + 1) % 3])]
            local x0 = (v0[0] + 1) * WIDTH / 2
            local y0 = (v0[1] + 1) * HEIGHT / 2
            local x1 = (v1[0] + 1) * WIDTH / 2
            local y1 = (v1[1] + 1) * HEIGHT / 2
            line(gc, x0, y0, x1, y1)
        end
    end
end

function Model:drawTriangles(gc)
    local lightDir = Vec3(0, 0, -1)
    local eye       = Vec3(0, 0, 2)
    local center    = Vec3(0, -0.05, -1)

	local strength = 1

    local zbuffer = {}

	local transform = Matrix4:rotationY(0):mul(Matrix4:scale(0.8, 0.8, 0.8))
    local view = Matrix4:lookat(eye, center, Vec3(0, 1, 0))
    local projection = Matrix4:identity()
    projection[3][2] = -1 / eye:sub(center):magnitude()

    local viewport = Matrix4:viewport(WIDTH / 8, HEIGHT / 8, WIDTH * 3 / 4, HEIGHT * 3 / 4)

    for i = 0, self.nfaces - 1, 1 do
        local face = self.faces[i]
        local screenCoords = {}
        local worldCoords = {}
        for j = 0, 2, 1 do
            local vertex = self.vertices[face[j]]
            screenCoords[j] = viewport:mul(projection:mul(view:mul(transform:mul(Matrix4:fromVector(vertex))))):toVector()
            worldCoords[j] = vertex
        end
        local normal = (worldCoords[2]:sub(worldCoords[0]):cross(worldCoords[1]:sub(worldCoords[0]))):normalize()
        local intensity = normal:dot(lightDir) * strength
        if intensity > 0 then
            setColor(gc, Vec3(intensity, intensity, intensity))
            triangleLineSweep(gc, screenCoords[0], screenCoords[1], screenCoords[2], zbuffer)
        end
    end
end
-----

-- load obj once
MODEL = Model(OBJ)

function on.paint(gc)
    local start = timer.getMilliSecCounter()
    MODEL:drawTriangles(gc)
    local finish = timer.getMilliSecCounter()
    print("Took", finish - start, "ms")
end