import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Power Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PowerDemoPage(),
    );
  }
}

class PowerDemoPage extends StatefulWidget {
  const PowerDemoPage({super.key});

  @override
  State<PowerDemoPage> createState() => _PowerDemoPageState();
}

class _PowerDemoPageState extends State<PowerDemoPage>
    with SingleTickerProviderStateMixin {
  double _sliderValue = 0.5;
  double _volume = 50.0;
  bool _isSwitchOn = false;
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  final List<Product> _products = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.purple,
    ).animate(_controller);

    _loadProducts();

    // Добавляем слушатель для бесконечного скролла
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        _loadMoreProducts();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
    });
  }

  void _onVolumeChanged(double value) {
    setState(() {
      _volume = value;
    });
  }

  void _onSwitchChanged(bool value) {
    setState(() {
      _isSwitchOn = value;
    });
  }

  // Загрузка продуктов (имитация)
  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2)); // Имитация задержки сети

    setState(() {
      _products.addAll(
        List.generate(
          20,
          (index) => Product(
            id: _products.length + index + 1,
            name: 'Product ${_products.length + index + 1}',
            price: 100 + index * 10,
            imageUrl:
                'https://manti-man.ru/wp-content/uploads/2023/08/new-sambuli-hinkal.webp',
          ),
        ),
      );
      _isLoading = false;
    });
  }

  // Подгрузка дополнительных продуктов
  Future<void> _loadMoreProducts() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2)); // Имитация задержки сети

    setState(() {
      _products.addAll(
        List.generate(
          10,
          (index) => Product(
            id: _products.length + index + 1,
            name: 'Product ${_products.length + index + 1}',
            price: 100 + index * 10,
            imageUrl:
                'https://manti-man.ru/wp-content/uploads/2023/08/new-sambuli-hinkal.webp',
          ),
        ),
      );
      _isLoading = false;
      _page++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Power Demo'),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Анимированный контейнер
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _colorAnimation.value!,
                          _colorAnimation.value!.withOpacity(0.5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        'Flutter is Awesome!',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Слайдер для настройки яркости
              Text(
                'Brightness: ${(_sliderValue * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 18),
              ),
              Slider(
                value: _sliderValue,
                onChanged: _onSliderChanged,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                label: '${(_sliderValue * 100).toStringAsFixed(0)}%',
              ),

              const SizedBox(height: 20),

              // Слайдер для настройки громкости
              Text(
                'Volume: ${_volume.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 18),
              ),
              Slider(
                value: _volume,
                onChanged: _onVolumeChanged,
                min: 0.0,
                max: 100.0,
                divisions: 10,
                label: _volume.toStringAsFixed(0),
              ),

              const SizedBox(height: 20),

              // Переключатель
              Row(
                children: [
                  const Text('Enable Feature:', style: TextStyle(fontSize: 18)),
                  const Spacer(),
                  Switch(
                    value: _isSwitchOn,
                    onChanged: _onSwitchChanged,
                    activeColor: Colors.deepPurple,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Кнопка с анимацией
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _controller.repeat(reverse: true);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  'Restart Animation',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),

              const SizedBox(height: 20),

              // Список продуктов
              const Text(
                'Products:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ..._products
                  .map((product) => ProductCard(product: product))
                  .toList(),

              // Индикатор загрузки
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, color: Colors.green),
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
