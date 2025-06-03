import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1. 定义状态变量
  final TextEditingController _inputValueController = TextEditingController(); // 输入框控制器
  String? _selectedFromUnit; // 选中的“从”单位
  String? _selectedToUnit; // 选中的“到”单位
  String _result = '0.0'; // 转换结果

  // 定义所有支持的单位类别和每个类别下的单位
  final Map<String, List<String>> _units = {
    '长度': ['米', '厘米', '英寸', '英尺'],
    '重量': ['千克', '克', '磅', '盎司'],
    '温度': ['摄氏度', '华氏度', '开尔文'],
  };

  String? _selectedCategory; // 当前选中的单位类别

  @override
  void initState() {
    super.initState();
    // 初始化时选择第一个类别和其下的第一个单位
    _selectedCategory = _units.keys.first;
    _selectedFromUnit = _units[_selectedCategory!]?.first;
    _selectedToUnit = _units[_selectedCategory!]?.first;
  }

  // 2. 转换逻辑函数
  void _convertUnits() {
    double? inputValue = double.tryParse(_inputValueController.text);

    if (inputValue == null || _selectedFromUnit == null || _selectedToUnit == null || _selectedCategory == null) {
      setState(() {
        _result = '请输入有效数值或选择单位';
      });
      return;
    }

    double convertedValue = 0.0;

    // 核心转换逻辑 (这里只是一个简化示例，实际应用需要更严谨的转换因子)
    if (_selectedCategory == '长度') {
      // 统一转换为米，再从米转换为目标单位
      double valueInMeters = 0.0;
      switch (_selectedFromUnit) {
        case '米':
          valueInMeters = inputValue;
          break;
        case '厘米':
          valueInMeters = inputValue / 100;
          break;
        case '英寸':
          valueInMeters = inputValue * 0.0254;
          break;
        case '英尺':
          valueInMeters = inputValue * 0.3048;
          break;
      }

      switch (_selectedToUnit) {
        case '米':
          convertedValue = valueInMeters;
          break;
        case '厘米':
          convertedValue = valueInMeters * 100;
          break;
        case '英寸':
          convertedValue = valueInMeters / 0.0254;
          break;
        case '英尺':
          convertedValue = valueInMeters / 0.3048;
          break;
      }
    } else if (_selectedCategory == '重量') {
      // 统一转换为千克，再从千克转换为目标单位
      double valueInKg = 0.0;
      switch (_selectedFromUnit) {
        case '千克':
          valueInKg = inputValue;
          break;
        case '克':
          valueInKg = inputValue / 1000;
          break;
        case '磅':
          valueInKg = inputValue * 0.453592;
          break;
        case '盎司':
          valueInKg = inputValue * 0.0283495;
          break;
      }

      switch (_selectedToUnit) {
        case '千克':
          convertedValue = valueInKg;
          break;
        case '克':
          convertedValue = valueInKg * 1000;
          break;
        case '磅':
          convertedValue = valueInKg / 0.453592;
          break;
        case '盎司':
          convertedValue = valueInKg / 0.0283495;
          break;
      }
    } else if (_selectedCategory == '温度') {
      // 温度转换比较特殊，需要直接进行转换
      if (_selectedFromUnit == '摄氏度' && _selectedToUnit == '华氏度') {
        convertedValue = (inputValue * 9 / 5) + 32;
      } else if (_selectedFromUnit == '华氏度' && _selectedToUnit == '摄氏度') {
        convertedValue = (inputValue - 32) * 5 / 9;
      } else if (_selectedFromUnit == '摄氏度' && _selectedToUnit == '开尔文') {
        convertedValue = inputValue + 273.15;
      } else if (_selectedFromUnit == '开尔文' && _selectedToUnit == '摄氏度') {
        convertedValue = inputValue - 273.15;
      } else if (_selectedFromUnit == '华氏度' && _selectedToUnit == '开尔文') {
        convertedValue = (inputValue - 32) * 5 / 9 + 273.15;
      } else if (_selectedFromUnit == '开尔文' && _selectedToUnit == '华氏度') {
        convertedValue = (inputValue - 273.15) * 9 / 5 + 32;
      } else {
        convertedValue = inputValue; // 同单位转换
      }
    }


    setState(() {
      _result = convertedValue.toStringAsFixed(2); // 格式化为两位小数
    });
  }

  @override
  void dispose() {
    _inputValueController.dispose(); // 释放控制器资源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('单位转换器'),
      ),
      body: SingleChildScrollView( // 使用 SingleChildScrollView 防止内容溢出
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 单位类别选择
            DropdownButton<String>(
              value: _selectedCategory,
              hint: const Text('选择单位类别'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                  // 当类别改变时，重置“从”和“到”单位为该类别下的第一个单位
                  _selectedFromUnit = _units[newValue!]?.first;
                  _selectedToUnit = _units[newValue!]?.first;
                  _result = '0.0'; // 重置结果
                });
              },
              items: _units.keys.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // 输入框
            TextField(
              controller: _inputValueController,
              keyboardType: TextInputType.number, // 只允许数字输入
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '输入值',
                hintText: '例如: 100',
              ),
              onChanged: (value) {
                // 输入时即时转换（可选，也可以只在点击按钮后转换）
                // _convertUnits();
              },
            ),
            const SizedBox(height: 20),

            // “从”单位选择
            DropdownButton<String>(
              value: _selectedFromUnit,
              hint: const Text('从...转换'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFromUnit = newValue;
                  _convertUnits(); // 单位改变时也进行转换
                });
              },
              items: _selectedCategory != null
                  ? _units[_selectedCategory!]?.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList()
                  : [], // 如果没有选择类别，则显示空列表
            ),
            const SizedBox(height: 20),

            // “到”单位选择
            DropdownButton<String>(
              value: _selectedToUnit,
              hint: const Text('转换到...'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedToUnit = newValue;
                  _convertUnits(); // 单位改变时也进行转换
                });
              },
              items: _selectedCategory != null
                  ? _units[_selectedCategory!]?.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList()
                  : [], // 如果没有选择类别，则显示空列表
            ),
            const SizedBox(height: 30),

            // 转换按钮
            ElevatedButton(
              onPressed: _convertUnits, // 点击按钮时调用转换函数
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '转换',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 30),

            // 结果显示
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '转换结果:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _result,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}