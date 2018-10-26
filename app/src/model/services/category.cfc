component output="false" {

    public any function getCategories(){
        return EntityLoad("category");
    }

    public any function getCategoryById(id){
        return entityLoadByPk("category",arguments.id);
    }

    public any function getCategoryByName( string categoryName ){
        return EntityLoad('category', { name: arguments.categoryname }, true );
    }
}