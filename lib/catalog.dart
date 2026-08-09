import 'models.dart';

const products = <Product>[
  Product(
    id: ProductId('arc-lamp'),
    name: 'Arc desk lamp',
    tagline: 'Warm light, focused work.',
    description:
        'A dimmable aluminum lamp with touch controls and a soft, flicker-free glow.',
    price: 89,
    category: Category.workspace,
    image: '💡',
    color: 0xFFF3D9A4,
    rating: 4.8,
    isNew: true,
  ),
  Product(
    id: ProductId('halo-speaker'),
    name: 'Halo speaker',
    tagline: 'Room-filling sound, quietly designed.',
    description:
        'A compact wireless speaker tuned for detailed sound and all-day listening.',
    price: 129,
    category: Category.audio,
    image: '🔊',
    color: 0xFFC8D8D2,
    rating: 4.9,
  ),
  Product(
    id: ProductId('cloud-headphones'),
    name: 'Cloud headphones',
    tagline: 'Your quiet place, anywhere.',
    description:
        'Lightweight over-ear headphones with adaptive noise cancellation.',
    price: 249,
    category: Category.audio,
    image: '🎧',
    color: 0xFFD8D0E8,
    rating: 4.7,
    isNew: true,
  ),
  Product(
    id: ProductId('field-bottle'),
    name: 'Field bottle',
    tagline: 'Cold for 24 hours. Clean forever.',
    description:
        'A double-wall steel bottle with a ceramic-lined interior and carry loop.',
    price: 38,
    category: Category.lifestyle,
    image: '🧊',
    color: 0xFFBAD7E8,
    rating: 4.6,
  ),
  Product(
    id: ProductId('orbit-keyboard'),
    name: 'Orbit keyboard',
    tagline: 'A better rhythm for every day.',
    description:
        'A low-profile mechanical keyboard with tactile switches and wireless pairing.',
    price: 159,
    category: Category.workspace,
    image: '⌨️',
    color: 0xFFE3C8B6,
    rating: 4.9,
  ),
  Product(
    id: ProductId('fold-tote'),
    name: 'Fold tote',
    tagline: 'Carries more. Packs down small.',
    description:
        'A water-resistant everyday tote made from recycled ripstop fabric.',
    price: 54,
    category: Category.lifestyle,
    image: 'assets/products/andras-vas-Bd7gNnWJBkU-unsplash.jpg',
    color: 0xFFD7D7B8,
    rating: 4.5,
  ),
];
