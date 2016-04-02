//
//  MenuListViewModel.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 17/01/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class SubCategory {
    var name = ""
    var slug = ""
    var code = ""
    
    init(name: String, slug: String, code: String) {
        self.name = name
        self.slug = slug
        self.code = code
        
    }
    
    class func newsSubCategoriesInDictionary(subCategoryArray: NSArray) -> [SubCategory]? {
        var subCategory = [SubCategory]()
        subCategoryArray.forEach({ (subCatrgoryDetail) -> () in
            if let subCategoryDictionary = subCatrgoryDetail as? NSDictionary {
                let name = subCategoryDictionary["name"] as? String ?? "name"
                let slug = subCategoryDictionary["slug"] as? String ?? "slug"
                let code = subCategoryDictionary["code"] as? String ?? "code"
                subCategory.append(SubCategory(name: name, slug: slug, code: code))
            }
        })
        return subCategory.count >= 1 ? subCategory : nil
    }
}

class Category {
    var name = ""
    var slug = ""
    var code = ""
    var subCategories: [SubCategory]?
    
    init(name: String, slug: String, code: String, subCategories: [SubCategory]?) {
        self.name = name
        self.slug = slug
        self.code = code
        self.subCategories = subCategories
    }
    
    class func newsCategoriesInDictionary(categoryArray: NSArray) -> [Category]?  {
        var categories = [Category]()
        categoryArray.forEach { (categoryDetail) -> () in
            if let categoryDictionary = categoryDetail as? NSDictionary {
                let name = categoryDictionary["section_name"] as? String ?? "Main Category"
                let slug = categoryDictionary["section_slug"] as? String ?? "Slug"
                let code = categoryDictionary["section_code"] as? String ?? "Section Code"
                var  subCategories: [SubCategory]?
                if let subCategoryArray = categoryDictionary["category_details"] as? NSArray {
                    subCategories = SubCategory.newsSubCategoriesInDictionary(subCategoryArray)
                }
                categories.append(Category(name: name, slug: slug, code: code, subCategories: subCategories))
            }
        }
        
        return categories.count > 1 ? categories : nil
    }
    
}

class NewsMenu: NSObject {
    var newsMenu: [Category]?
    
    init(newsMenuDictionary: NSDictionary) {
        if let newsSectionArray = newsMenuDictionary["data"] as? NSArray {
            self.newsMenu = Category.newsCategoriesInDictionary(newsSectionArray)
        }
    }
    
    class func loadMenuFromJsonFile() -> NewsMenu? {
        
        let filePath = NSBundle.mainBundle().pathForResource("menu_details", ofType: "json")
        
        if let filePath = filePath {
            do {
                let jsonData = try NSData(contentsOfFile: filePath, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                do {
                    let NewsDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    if let NewsDictionary = NewsDictionary {
                        return NewsMenu.init(newsMenuDictionary: NewsDictionary)
                    } else {
                        return nil
                    }
                } catch {
                    
                }
                return nil
                
            } catch{
                
            }
        }
        return nil
    }
    
}
