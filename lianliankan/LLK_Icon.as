package lianliankan {
    import flash.display.MovieClip;

    public class LLK_Icon {
        private var _id:int;
        private var _type:int;
        private var _instance:MovieClip;

        public function LLK_Icon()
        {
            super();
        }

        public function get id():int
        {
            return this._id;
        }

        public function get type():int
        {
            return this._type;
        }

        public function get instance():MovieClip
        {
            return this._instance;
        }

        public function set id(id:int):void
        {
            this._id = id;
        }

        public function set type(type:int):void
        {
            this._type = type;
        }

        public function set instance(instance:MovieClip):void
        {
            this._instance = instance;
        }

    }

}
