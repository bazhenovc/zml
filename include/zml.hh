/** Zero-bloated Markup Language
	CC0 License

	This software is provided 'as-is', without any express or implied
	warranty. In no event will the authors be held liable for any damages
	arising from the use of this software.

	Permission is granted to anyone to use this software for any purpose,
	including commercial applications, and to alter it and redistribute it
	freely, subject to the following restrictions:

	1. The origin of this software must not be misrepresented; you must not
	claim that you wrote the original software. If you use this software
	in a product, an acknowledgment in the product documentation would be
	appreciated but is not required. 
	2. Altered source versions must be plainly marked as such, and must not be
	misrepresented as being the original software. 
	3. This notice may not be removed or altered from any source distributio
**/

#pragma once

#include <vector>
#include <string>

namespace zml
{

class Field
{
private:

	std::string _name;
	std::string _value;

public:

	inline void SetName(const std::string& newName)
	{ _name = newName; }

	inline const std::string& GetName() const
	{ return _name; }

	inline void SetValue(const std::string& newValue)
	{ _value = newValue; }
	
	inline const std::string& GetValue() const
	{ return _value; }
};
typedef std::vector<Field> FieldVector;

class Object
{
private:

	std::string         _name;
	FieldVector         _fields;
	std::vector<Object> _children;

public:

	inline void SetName(const std::string& newName)
	{ _name = newName; }

	inline const std::string& GetName() const
	{ return _name; }


	inline FieldVector& GetFields()
	{ return _fields; }

	inline const FieldVector& GetFields() const
	{ return _fields; }

	inline std::vector<Object>& GetChildren()
	{ return _children; }

	inline const std::vector<Object>& GetChildren() const
	{ return _children; }
};
typedef std::vector<Object> ObjectVector;

class Document
{

private:

	Object _rootObject;

public:

	Document()
	{
		_rootObject.SetName("root");
	}

	inline void SetRootObject(const Object& newRoot)
	{ _rootObject = newRoot; }

	inline Object& GetRootObject()
	{ return _rootObject; }

	inline const Object& GetRootObject() const
	{ return _rootObject; }

	bool Load(const std::string& buffer);
};

}