package lianliankan {
    import flash.system.ApplicationDomain;

    public class LLK_Util {

        public function LLK_Util()
        {

        }

        public static function getResInDomian(url:String, cls:String, callback:Function, domain:ApplicationDomain = null):void
        {
            var res:*;
            if(domain != null){
                //查看指定域是否可以获取实例
                res = getInstance(cls, domain);
                if(res != null){
                    callback.apply(null, [res]);
                    return;
                }
            }
        }

        public static function getInstance(className:String, domain:ApplicationDomain):* {
            var instance:* = null;
            if( domain.hasDefinition(className) ){
                instance = new ( domain.getDefinition(className) );
            }
            return instance;
        }


    }

}
