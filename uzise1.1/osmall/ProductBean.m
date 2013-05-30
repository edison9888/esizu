

#import "ProductBean.h"

@implementation ProductBean
@synthesize price,quantity,productId,productName,productTypeName,datetime,productNO,productTypeId,retallPrice,shopcount,sellCount,introduce,comments,product_url,shopPrice;
//,product_url_list,product_url_imageview;


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeDouble:price forKey:@"price"];
    [aCoder encodeInt:quantity forKey:@"quantity"];
    [aCoder encodeInt:productId forKey:@"productId"];
    [aCoder encodeObject:productName forKey:@"productName"];
    [aCoder encodeObject:productTypeName forKey:@"productTypeName"];
    [aCoder encodeObject:datetime forKey:@"datetime"];
    [aCoder encodeObject:productNO forKey:@"productNO"];
    [aCoder encodeInt:productTypeId forKey:@"productTypeId"];
    [aCoder encodeDouble:retallPrice forKey:@"retallPrice"];
    [aCoder encodeDouble:shopPrice forKey:@"shopPrice"];
    [aCoder encodeInt:shopcount forKey:@"shopcount"];
    [aCoder encodeInt:sellCount forKey:@"sellCount"];
    [aCoder encodeObject:introduce forKey:@"introduce"];
    [aCoder encodeInt:comments forKey:@"comments"];
    [aCoder encodeObject:product_url forKey:@"product_url"];
  //  [aCoder encodeObject:product_url_list forKey:@"product_url_list"];
  //  [aCoder encodeObject:product_url_imageview forKey:@"product_url_imageview"];
    
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    shopPrice= [aDecoder decodeDoubleForKey:@"shopPrice"] ;
    price= [aDecoder decodeDoubleForKey:@"price"] ;
    quantity= [aDecoder decodeIntegerForKey:@"quantity"];
    productId= [aDecoder decodeIntegerForKey:@"productId"];
    productName= [aDecoder decodeObjectForKey:@"productName"];
    productTypeName= [aDecoder decodeObjectForKey:@"productTypeName"];
    datetime= [aDecoder decodeObjectForKey:@"datetime"];
    productNO=[aDecoder decodeObjectForKey:@"productNO"];
    productTypeId=[aDecoder decodeIntegerForKey:@"productTypeId"];
    retallPrice=[aDecoder decodeDoubleForKey:@"retallPrice"];
    shopcount=[aDecoder decodeIntegerForKey:@"shopcount"];
    sellCount=[aDecoder decodeIntegerForKey:@"sellCount"];
    introduce=[aDecoder decodeObjectForKey:@"introduce"];
    comments=[aDecoder decodeIntegerForKey:@"comments"];
    product_url=[aDecoder decodeObjectForKey:@"product_url"];
  //  product_url_list=[aDecoder decodeObjectForKey:@"product_url_list"];
  //  product_url_imageview=[aDecoder decodeObjectForKey:@"product_url_imageview"];
    return self;
}


-(id)copyWithZone:(NSZone *)zone{
    id newProduct = [[[self class] allocWithZone: zone] init];
    [newProduct setPrice:price];
    [newProduct setQuantity:quantity];
    [newProduct setProductId:productId];
    [newProduct setProductName:productName];
    [newProduct setProductTypeName:productTypeName];
    [newProduct setDatetime:datetime];
    [newProduct setProductNO:productNO];
    [newProduct setProductTypeId:productTypeId];
    [newProduct setRetallPrice:retallPrice];
    [newProduct setShopcount:shopcount];
    [newProduct setSellCount:sellCount];
    [newProduct setIntroduce:introduce];
    [newProduct setComments:comments];
    [newProduct setProduct_url:product_url];
    [newProduct setShopPrice:shopPrice];
  //  [newProduct setProduct_url_list:product_url_list];
  //  [newProduct setProduct_url_imageview:product_url_imageview];
    return newProduct; 
}

@end
