import '../models/property_type_model.dart';

const String rupee = '₹';
const List<String> karnatakaDistricts = [
  'Bangalore',
  'Hyderabad',

  // 'Bagalkot',
  // 'Ballari (Bellary)',
  // 'Belagavi (Belgaum)',
  // 'Bengaluru Rural',
  // 'Bengaluru Urban',
  // 'Bidar',
  // 'Chamarajanagar',
  // 'Chikballapur',
  // 'Chikkamagaluru (Chikmagalur)',
  // 'Chitradurga',
  // 'Dakshina Kannada',
  // 'Davangere',
  // 'Dharwad',
  // 'Gadag',
  // 'Hassan',
  // 'Haveri',
  // 'Kalaburagi (Gulbarga)',
  // 'Kodagu (Coorg)',
  // 'Kolar',
  // 'Koppal',
  // 'Mandya',
  // 'Mysuru (Mysore)',
  // 'Raichur',
  // 'Ramanagara',
  // 'Shivamogga (Shimoga)',
  // 'Tumakuru (Tumkur)',
  // 'Udupi',
  // 'Uttara Kannada (Karwar)',
  // 'Vijayapura (Bijapur)',
  // 'Yadgir'
];

List<PropertyTypeModel> propertyType = [
  PropertyTypeModel(
      id: 1, name: 'Flats', iconPath: 'assets/images/residential.png'),
  PropertyTypeModel(id: 2, name: 'Plots', iconPath: 'assets/images/plot.png'),
  PropertyTypeModel(
      id: 3, name: 'Resale', iconPath: 'assets/images/resale.png'),
  PropertyTypeModel(
      id: 4, name: 'Farmlands', iconPath: 'assets/images/farmland.png'),
  PropertyTypeModel(
      id: 5,
      name: 'Commercial Properties',
      iconPath: 'assets/images/commercial.png'),
  PropertyTypeModel(
      id: 6, name: 'Investments', iconPath: 'assets/images/investment.png'),
];

List<String> propertyTypeName = [
  'Flats',
  'Plots',
  'Resale',
  'Farmlands',
  'Commercial Properties',
  'Investments',
];

List<String> leadType = ['Property', 'Loan', 'Construction', 'Interior'];
