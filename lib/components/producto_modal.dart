import 'package:app_movil/core/colores_style.dart';
import 'package:app_movil/models/productos.dart';
import 'package:app_movil/models/productos.dart';
import 'package:app_movil/services/producto_service.dart';
import 'package:app_movil/services/categoria_service.dart';
import 'package:app_movil/services/subcategoria_service.dart';
import 'package:flutter/material.dart';

class ProductoModal extends StatefulWidget {
  final Producto? producto;
  final Function() onGuardado;

  const ProductoModal({super.key, this.producto, required this.onGuardado});

  @override
  State<ProductoModal> createState() => _ProductoModalState();
}

class _ProductoModalState extends State<ProductoModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nombreCtrl;
  late TextEditingController descripcionCtrl;
  late TextEditingController precioCtrl;
  late TextEditingController disponibilidadCtrl;

  final ProductoService productoService = ProductoService();
  final CategoriaService categoriaService = CategoriaService();
  final SubcategoriaService subcategoriaService = SubcategoriaService();

  bool isLoading = false;
  List<Categoria> categorias = [];
  List<SubCategoria> subcategorias = [];
  List<SubCategoria> subcategoriasFiltradas = [];

  int? categoriaSeleccionada;
  int? subcategoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    nombreCtrl = TextEditingController(text: widget.producto?.nombre ?? '');
    descripcionCtrl = TextEditingController(
      text: widget.producto?.descripcion ?? '',
    );
    precioCtrl = TextEditingController(
      text: widget.producto?.precio.toString() ?? '',
    );
    disponibilidadCtrl = TextEditingController(
      text: widget.producto?.disponibilidad?.toString() ?? '',
    );

    subcategoriaSeleccionada = widget.producto?.subcategoriaId;

    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final cats = await categoriaService.obtenerCategorias();
    final subs = await subcategoriaService.obtenerSubcategorias();

    setState(() {
      categorias = cats;
      subcategorias = subs;

      // Si estamos editando, pre-seleccionar la categoría
      if (widget.producto?.subcategoria?.categoriaId != null) {
        categoriaSeleccionada = widget.producto!.subcategoria!.categoriaId;
        _filtrarSubcategorias(categoriaSeleccionada!);
      }
    });
  }

  void _filtrarSubcategorias(int categoriaId) {
    setState(() {
      subcategoriasFiltradas = subcategorias
          .where((sub) => sub.categoriaId == categoriaId)
          .toList();

      // Si la subcategoría seleccionada no está en las filtradas, resetear
      if (subcategoriaSeleccionada != null) {
        final existe = subcategoriasFiltradas.any(
          (sub) => sub.id == subcategoriaSeleccionada,
        );
        if (!existe) {
          subcategoriaSeleccionada = null;
        }
      }
    });
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    if (subcategoriaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes seleccionar una subcategoría')),
      );
      return;
    }

    setState(() => isLoading = true);

    final nombre = nombreCtrl.text.trim();
    final descripcion = descripcionCtrl.text.trim();
    final precio = double.tryParse(precioCtrl.text.trim()) ?? 0;
    final disponibilidad = int.tryParse(disponibilidadCtrl.text.trim());

    Producto? resultado;

    if (widget.producto == null) {
      // Crear nuevo
      resultado = await productoService.crearProducto(
        nombre: nombre,
        descripcion: descripcion.isEmpty ? null : descripcion,
        precio: precio,
        disponibilidad: disponibilidad,
        subcategoriaId: subcategoriaSeleccionada!,
      );
    } else {
      // Actualizar existente
      resultado = await productoService.actualizarProducto(
        id: widget.producto!.id,
        nombre: nombre,
        descripcion: descripcion.isEmpty ? null : descripcion,
        precio: precio,
        disponibilidad: disponibilidad,
        subcategoriaId: subcategoriaSeleccionada,
      );
    }

    setState(() => isLoading = false);

    if (resultado != null) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.producto == null
                  ? 'Producto creado correctamente'
                  : 'Producto actualizado correctamente',
            ),
          ),
        );
        widget.onGuardado();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar el producto')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.producto == null ? 'Agregar Plato' : 'Editar Plato',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Nombre
                TextFormField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del plato',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.restaurant_menu),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // Descripción
                TextFormField(
                  controller: descripcionCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Descripción (opcional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                ),
                const SizedBox(height: 15),

                // Precio
                TextFormField(
                  controller: precioCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Precio (Bs)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El precio es requerido';
                    }
                    final precio = double.tryParse(value.trim());
                    if (precio == null || precio <= 0) {
                      return 'Ingrese un precio válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // Disponibilidad
                TextFormField(
                  controller: disponibilidadCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Disponibilidad (opcional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.inventory),
                  ),
                ),
                const SizedBox(height: 15),

                // Categoría
                DropdownButtonFormField<int>(
                  value: categoriaSeleccionada,
                  decoration: const InputDecoration(
                    labelText: 'Categoría',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: categorias.map((cat) {
                    return DropdownMenuItem<int>(
                      value: cat.id,
                      child: Text(cat.nombre),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      categoriaSeleccionada = value;
                      subcategoriaSeleccionada = null;
                      if (value != null) {
                        _filtrarSubcategorias(value);
                      } else {
                        subcategoriasFiltradas = [];
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Selecciona una categoría';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // Subcategoría
                DropdownButtonFormField<int>(
                  value: subcategoriaSeleccionada,
                  decoration: const InputDecoration(
                    labelText: 'Subcategoría',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.subdirectory_arrow_right),
                  ),
                  items: subcategoriasFiltradas.map((sub) {
                    return DropdownMenuItem<int>(
                      value: sub.id,
                      child: Text(sub.nombre),
                    );
                  }).toList(),
                  onChanged: categoriaSeleccionada == null
                      ? null
                      : (value) {
                          setState(() {
                            subcategoriaSeleccionada = value;
                          });
                        },
                  validator: (value) {
                    if (value == null) {
                      return 'Selecciona una subcategoría';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Botones
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isLoading
                            ? null
                            : () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _guardar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColoresStyle.acento,
                          foregroundColor: Colors.white,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Guardar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    descripcionCtrl.dispose();
    precioCtrl.dispose();
    disponibilidadCtrl.dispose();
    super.dispose();
  }
}
