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

#include <zml.hh>

#include <iostream>
#include <fstream>

std::string ReadFile(const char *filename)
{
	std::ifstream in(filename, std::ios::in | std::ios::binary);
	std::string contents;
	if (in) {
		in.seekg(0, std::ios::end);
		contents.resize(in.tellg());
		in.seekg(0, std::ios::beg);
		in.read(&contents[0], contents.size());
	}
	return contents;
}

void PrintTree(const zml::Object& object, const std::string& indent = "")
{
	std::cout << indent << object.GetName() << std::endl;
	for (auto& field: object.GetFields()) {
		std::cout << indent << "\t" << field.GetName() << " = " << field.GetValue() << std::endl;
	}
	for (auto& child: object.GetChildren())
		PrintTree(child, indent + "\t");
}

int main(int argc, char** argv)
{
	if (argc < 2) {
		std::cout << "usage: zml_print file.zml" << std::endl;
		return 1;
	}

	zml::Document doc;
	if (doc.Load(ReadFile(argv[1]))) {
		PrintTree(doc.GetRootObject());
	}

	return 0;
}
